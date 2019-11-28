clear all;
display_active = true;

%% INIT TRACK
disp('Startar bilbanan. Avsluta med q.')
hf=figure('position', [0 0 eps eps], 'menubar', 'none');

initialize_counters(1)
initialize_counters(2)

config_IOs

start_race(1)
start_race(2)

%% INIT
global log_debug;
log_debug = true;
global log_verbose;
log_verbose = false;
% INIT DISPLAY
if display_active
    addpath display/ClientServerApp/Release
    cd display/ClientServerApp/Release
    !startServer
    cd ../../..
end

display = struct;
display.data = [];
display.out = 0;
display.shm = 0;
display.shm_interp = struct;
display.shm_interp.ack = 0;
display.shm_interp.start_code = '';
display.shm_interp.data = [];
display.last_send = tic;
display.send_interval = 0.5;

load('bilbana\files\Bana.mat')

car1 = struct;
car1.num = 1;
car1.running = false;
car1.automatic = true;
car1.stopping = false;
car1.stopped = false;
car1.segment = 1;
car1.lap = 0;
car1.lap_times = [];
car1.seg_times = [];
car1.position = 0;
car1.pos_at  = [0.0 2.53 3.05 4.73 7.68 8.98 10.93 14.69 17.57 19.60];
car1.seg_len = [2.53 0.53 1.68 2.92 1.2 2.01 3.83 2.89 1.99];
car1.percents = [0.088, 0.022, 0.102, 0.15, 0.058, 0.11, 0.212, 0.146, 0.113];  % TODO
car1.map = Bana1;
%car1.approximation = [];
car1.miss_probability = 0.0;
car1.constant = 0.1;
car1.stop = false;
car1.governs = [];
car1.forecasts = [];
car1.forecasts_naive = [];

car2 = struct;
car2.num = 2;
car2.running = false;
car2.automatic = true;
car2.stopping = false;
car2.stopped = false;
car2.segment = 1;
car2.lap = 0;
car2.lap_times = [];
car2.seg_times = [];
car2.position = 0;
car2.pos_at  = [0.0 2.53 3.05 4.92 7.62 9.02 10.72 14.68 17.76 19.95];
car2.seg_len = [2.53 0.52 1.87 2.70 1.40 1.70 4.03 3.08 2.19];
car2.percents = [0.088, 0.022, 0.102, 0.15, 0.058, 0.11, 0.212, 0.146, 0.113];
car2.map = Bana2;
car2.miss_probability = 0.05;
car2.constant = 0.1;
car2.stop = false;
car2.governs = [];
car2.forecasts = [];
car2.forecasts_naive = [];

boot1 = struct;
boot1.status = false;
boot1.time = tic;

boot2 = struct;
boot2.status = false;
boot2.time = tic;

halt = false;

ref_time = 13;

t = 0;
highToc = 0;

pause(1);

%% DRAW DISPLAY
matlabclient(1, get_smallpackage([ ...
	put_text(160, 30, 'C', 'Choose which car to drive'), ...
	toggle(98 , 60 , 130, 90 , 11, 12, 'C', '1'), ...  % ACTIVATE TRACK 1
	toggle(102, 98 , 126, 122, 13, 14, 'C', 'M'), ...  % MANUAL CONTROL TRACK 1
	toggle(190, 60 , 222, 90 , 21, 22, 'C', '2'), ...  % ACTIVATE TRACK 2
	toggle(194, 98 , 218, 122, 23, 61, 'C', 'M') ...  % MANUAL CONTROL TRACK 2
	]));
pause(0.5);
matlabclient(1, get_smallpackage([ ...
	put_text(160, 142, 'C', '13.0'), ...  % CURRENT REFERENCE TIME
	key(98 , 130, 130, 160, 41, 42, 'C', '-'), ...  % DECREASE REFERENCE TIME
	key(190, 130, 220, 160, 43, 44, 'C', '+'), ...  % INCREASE REFERENCE TIME
	key(272, 192, 304, 224, 31, 32, 'C', 'S') ...  % START BUTTON
	key(272, 192, 304, 224, 31, 32, 'C', 'S') ...  % START BUTTON
	]));

%% CHECK DISPLAY BUTTONS
display.last_check = tic;
done = false;
while 1
	pause(0.1);
	if toc(display.last_check) > 0.4
		verbose('DISPLAY', 'toc > 0.4');
		display.last_check = tic;

		% read internal mem from last send
		[display.out, display.shm] = matlabclient(2);
		[display.shm_interp.ack, display.shm_interp.start_code, display.shm_interp.data] = get_response(display.shm);

		verbose('DISPLAY', 'Requesting internal mem for next cycle...');
		% request internal mem
		matlabclient(1, hex2dec(['12'; '01'; '53'; '66']));

		if isempty(display.shm_interp.data)
			verbose('DISPLAY', 'No response');
			continue
		end
		debug('DISPLAY', ['Reading ', num2str(length(display.shm_interp.data)), ' package(-s)']);

		update_ref_time = false;
		for i = 1:length(display.shm_interp.data)
			data = display.shm_interp.data(i);
			if data.data == 32
				debug('DISPLAY', ...
					'Start-button pressed, exiting when no more packages');
				done = true;
			elseif data.data == 11
				debug('DISPLAY', 'Enabling car 1');
				car1.running = true;
			elseif data.data == 12
				debug('DISPLAY', 'Disabling car 1');
				car1.running = false;
			elseif data.data == 13
				debug('DISPLAY', 'Enabling car 1 manual');
				car1.automatic = false;
			elseif data.data == 14
				debug('DISPLAY', 'Disabling car 1');
				car1.automatic = true;
			elseif data.data == 21
				debug('DISPLAY', 'Enabling car 2');
				car2.running = true;
			elseif data.data == 22
				debug('DISPLAY', 'Disabling car 2');
				car2.running = false;
			elseif data.data == 23
				debug('DISPLAY', 'Enabling car 2 manual');
				car2.automatic = false;
			elseif data.data == 24
				debug('DISPLAY', 'Disabling car 2 manual');
				car2.automatic = true;
			elseif data.data == 41
				% ignore
			elseif data.data == 42
				debug('DISPLAY', ['Decreasing ref_time to ', num2str(ref_time)]);
				ref_time = max(ref_time - 0.5, 12.0);
				update_ref_time = true;
			elseif data.data == 43
				% ignore
			elseif data.data == 44
				debug('DISPLAY', ['Increasing ref_time to ', num2str(ref_time)]);
				ref_time = min(ref_time + 0.5, 15.0);
				update_ref_time = true;
			end
		end
		if done == true
			break
		end
		if update_ref_time == true
			pause(0.4);
			matlabclient(1, get_smallpackage(put_text(160, 142, 'C', num2str(ref_time, '%.1f'))));
		end
		display.last_check = tic;
	end
end

car1.ref_time = ref_time;
car2.ref_time = ref_time;

pause(0.5);
matlabclient(1, get_smallpackage(clear_display()))
pause(0.5);

matlabclient(1, get_smallpackage([ ...
    bar_graph('O', 1, 30, 30, 54, 210, 0, 64, 1, 1), ...
    bar_graph('O', 2, 266, 30, 290, 210, 0, 64, 1, 1) ...
    ]));

boot1.status = car1.running && car1.automatic;
boot2.status = car2.running && car2.automatic;

%% MAIN LOOP
while 1
    readTime = tic;
    %% PRE-LOOP
    if strcmp(get(hf,'currentcharacter'),'q')
        close(hf)
        break
    elseif strcmp(get(hf, 'currentcharacter'), 's')
        car1.stopping = true;
        car2.stopping = true;
    end
    
    figure(hf)
    drawnow
    
    [car1, halt, display.data] = do_car(car1, t, display.data, boot1);
    if halt
        break
    end
    [car2, halt, display.data] = do_car(car2, t, display.data, boot2);
    if halt
        break
    end
    
    %% BOOTSTRAP
    if boot1.status
        [car1, boot1] = do_boot(car1, boot1);
    end
    if boot2.status
        [car2, boot2] = do_boot(car2, boot2);
    end
    %% GOVERNOR
    if not(boot1.status) && car1.lap ~= 0
        car1 = do_gov(car1);
    end
    if not(boot2.status) && car2.lap ~= 0
        car2 = do_gov(car2);
    end
    %%
    
    if (~car2.running && car1.stopped) || (~car1.running && car2.stopped) || (car1.stopped && car2.stopped)
        break;
    end
    
    %% END OF LOOP
    while 1                     %Whileloop med paus som k�rs till pausen �verskridit 0.07 sekunder
        if display_active
            % DISPLAY
            display.send_delay = tic;
            if toc(display.last_send) > display.send_interval && display_active
                % queue control signal
                if car1.running && car1.automatic
                    % display.data = [display.data, put_text(20, 16 + (16 * 1), 'L', num2str(car1.u))];
                    display.data = [display.data, update_bar_graph(1, car1.u)];
                end
                if car2.running && car2.automatic
                    % display.data = [display.data, put_text(20, 16 + (16 * 2), 'L', num2str(car2.u))];
                    display.data = [display.data, update_bar_graph(2, car2.u)];
                end

                % send all queued data
                if ~isempty(display.data)
                    [display.out] = matlabclient(1, get_smallpackage(display.data));
                    display.data = [];
                end
                display.last_send = tic;

                % read internal mem from last send
                [display.out, display.shm] = matlabclient(2);
                [display.shm_interp.ack, display.shm_interp.start_code, display.shm_interp.data] = get_response(display.shm);

                % request internal mem
                % matlabclient(1, hex2dec(['12'; '01'; '53'; '66']));
            end
        end
        % disp(strjoin({'display took additional ', num2str(toc(display.send_delay))}));
        % ACTUAL END OF LOOP
        t = toc(readTime);
        
        if t > 0.07
            if t > highToc
                highToc = t;     %Om det nya v�rdet p� pausen �r h�gre �n den tidigare h�gsta s� sparas det som den h�gsta
            end
            if t > 0.1
                % beep;
            end
            break;
        end
        pause(0.001);
    end
end

%% END OF RACE
disp(highToc);
disp(car1);
disp(car2);
terminate(1);
terminate(2);

%% SAVE VARIABLES FROM CAR STRUCT
dateStr = datestr(now, 'yyyy-mm-dd');
timeStr = datestr(now, 'HH.MM');

if car1.lap > 2
    filenameMat1 = strjoin({'bilbana1_', dateStr, 'T', timeStr, '.mat'}, '');
    save(filenameMat1, '-struct', 'car1');
end
if car2.lap > 2
    filenameMat2 = strjoin({'bilbana2_', dateStr, 'T', timeStr, '.mat'}, '');
    save(filenameMat2, '-struct', 'car2');
end

%% DISPLAY POST RACE
if display_active
	% format segment times correctly
	car1.seg_times_format = format_seg_times(car1);
	car2.seg_times_format = format_seg_times(car2);
	pause(0.2);
	matlabclient(1, get_smallpackage(clear_display()));
	display_post_race_graphs(car1.seg_times_format, car2.seg_times_format, ...
			car1.lap_times, car2.lap_times, ref_time);
end

%% CLEAN UP
if display_active
    matlabclient(3);
end
