%% INIT
% INIT DISPLAY
addpath display/ClientServerApp/Release
cd display/ClientServerApp/Release
!startServer
cd ../../..

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

disp('Startar bilbanan. Avsluta med q.')
hf=figure('position', [0 0 eps eps], 'menubar', 'none');

% initialize_counters(1)
% initialize_counters(2)

% config_IOs

load('bilbana\files\Bana1.mat')
load('bilbana\files\Bana2.mat')

% start_race(1)
% start_race(2)

car1 = struct;
car1.num = 1;
car1.running = false;
car1.automatic = false;
car1.segment = 1;
car1.lap = 0;
car1.lap_times = [];
car1.seg_times = [];
car1.position = 0;
car1.seg_len = [0.0 2.53 3.05 4.73 7.68 8.98 10.93 14.69 17.57];
car1.map = Bana1;
car1.approximation = [];
car1.miss_probability = 0.0;

car2 = struct;
car2.num = 2;
car2.running = false;
car2.automatic = false;
car2.segment = 1;
car2.lap = 0;
car2.lap_times = [];
car2.seg_times = [];
car2.position = 0;
car2.seg_len = [0.0 2.53 3.05 4.92 7.60 8.84 10.65 14.68 17.76];
car2.map = Bana2;
car2.miss_probability = 0.05;

ref_time = 13;

t = 0;
highToc = 0;

%% DRAW DISPLAY
matlabclient(1, get_smallpackage([ ...
	put_text(160, 30, 'C', 'Choose which car to drive'), ...
	define_touch_switch(98 , 60 , 130, 90 , 11, 12, 'C', '1'), ...  % ACTIVATE TRACK 1
	define_touch_switch(102, 98 , 126, 122, 13, 14, 'C', 'M'), ...  % MANUAL CONTROL TRACK 1
	define_touch_switch(190, 60 , 222, 90 , 21, 22, 'C', '2'), ...  % ACTIVATE TRACK 2
	define_touch_switch(194, 98 , 218, 122, 23, 61, 'C', 'M') ...  % MANUAL CONTROL TRACK 2
]));
pause(0.5);
matlabclient(1, get_smallpackage([ ...
    put_text(160, 120, 'C', '13.0'), ...  % CURRENT REFERENCE TIME
	define_touch_key(   98 , 110, 130, 140, 41, 42, 'C', '-'), ...  % DECREASE REFERENCE TIME
	define_touch_key(   190, 110, 220, 140, 43, 44, 'C', '+'), ...  % INCREASE REFERENCE TIME
	define_touch_key(   272, 192, 304, 224, 31, 32, 'C', 'S') ...  % START BUTTON
	%TODO CLEAR BUTTON
]));

%% CHECK DISPLAY BUTTONS
display.last_check = tic;
done = false;
while 1
	pause(0.1);
	if toc(display.last_check) > 0.4
        display.last_check = tic;
        
		% read internal mem from last send
		[display.out, display.shm] = matlabclient(2);
		[display.shm_interp.ack, display.shm_interp.start_code, display.shm_interp.data] = get_response(display.shm);

		% request internal mem
		matlabclient(1, hex2dec(['12'; '01'; '53'; '66']));
		if isempty(display.shm_interp.data)
			continue
		end
		update_ref_time = false;
		for i = 1:length(display.shm_interp.data)
			disp(num2str(length(display.shm_interp.data)))
			data = display.shm_interp.data(i);
			disp(data)
			if data.data == 32
				done = true;
			elseif data.data == 11
				car1.running = true;
			elseif data.data == 12
				car1.running = false;
			elseif data.data == 13
				car1.automatic = false;
			elseif data.data == 14
				car1.automatic = true;
			elseif data.data == 21
				car2.running = true;
			elseif data.data == 22
				car2.running = false;
			elseif data.data == 23
				car2.automatic = false;
			elseif data.data == 24
				car2.automatic = true;
			elseif data.data == 41
				% ignore
			elseif data.data == 42
				ref_time = max(ref_time - 0.5, 12.0);
				update_ref_time = true;
			elseif data.data == 43
				% ignore
			elseif data.data == 44
				ref_time = min(ref_time + 0.5, 15.0);
				update_ref_time = true;
			end
		end
		if done == true
			break
		end
		if update_ref_time == true
			pause(0.4);
			matlabclient(1, get_smallpackage(put_text(160, 120, 'C', num2str(ref_time, '%.1f'))));
		end
		display.last_check = tic;
	end
end

%{
ref_time = input('Vilken referenstid ska användas? [13] ', 's');
ref_time = str2double(ref_time);
if isnan(ref_time)
    ref_time = 13;
elseif not(isreal(ref_time))
    ref_time = 13;
end
%}

debug('DISPLAY', ['CAR1.RUNNING=', car1.running, ', CAR1.AUTOMATIC=', car1.automatic])
debug('DISPLAY', ['CAR2.RUNNING=', car2.running, ', CAR2.AUTOMATIC=', car2.automatic])
debug('DISPLAY', ['CHOSEN REFERENCE TIME=', ref_time])

matlabclient(1, get_smallpackage([define_bar_graph('O', 2, 266, 30, 290, 210, 0, 64, 1, 1)]));

%% MAIN LOOP
while 1
	readTime = tic;
	%% PRE-LOOP
	if strcmp(get(hf,'currentcharacter'),'q')
		close(hf)
		break
	end

	figure(hf)
	drawnow

	[car1, car1.stop, display.data] = do_car(car1, t, display.data);
	[car2, car2.stop, display.data] = do_car(car2, t, display.data);

	if car1.stop == true
		disp('stopped by car 1');
		break;
	end
	if car2.stop == true
		disp('stopped by car 2');
		break;
	end
<<<<<<< HEAD
    
    %% END OF LOOP
    while 1                     %Whileloop med paus som kï¿½rs till pausen ï¿½verskridit 0.07 sekunder
        % DISPLAY
        display.send_delay = tic;
        if toc(display.last_send) > display.send_interval
            % queue control signal
            if car1.running && car1.automatic
                % display.data = [display.data, put_text(20, 16 + (16 * 1), 'L', num2str(car1.u))];
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
        % disp(strjoin({'display took additional ', num2str(toc(display.send_delay))}));
        % ACTUAL END OF LOOP
        t = toc(readTime);
        
        if t > 0.07
            if t > highToc
                highToc = t;     %Om det nya vï¿½rdet pï¿½ pausen ï¿½r hï¿½gre ï¿½n den tidigare hï¿½gsta sï¿½ sparas det som den hï¿½gsta
            end
            if t > 0.1
                % beep;
            end
            break;
        end
        pause(0.001);
    end
=======

	%% END OF LOOP
	while 1                     %Whileloop med paus som kï¿½rs till pausen ï¿½verskridit 0.07 sekunder
		% DISPLAY
		display.send_delay = tic;
		if toc(display.last_send) > display.send_interval
			% queue control signal
			if car1.running && car1.automatic
				display.data = [display.data, put_text(20, 16 + (16 * 1), 'L', num2str(car1.u))];
			end
			if car2.running && car2.automatic
				display.data = [display.data, put_text(20, 16 + (16 * 2), 'L', num2str(car2.u))];
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
		% disp(strjoin({'display took additional ', num2str(toc(display.send_delay))}));
		% ACTUAL END OF LOOP
		t = toc(readTime);

		if t > 0.07
			if t > highToc
				highToc = t;     %Om det nya vï¿½rdet pï¿½ pausen ï¿½r hï¿½gre ï¿½n den tidigare hï¿½gsta sï¿½ sparas det som den hï¿½gsta
			end
			if t > 0.1
				% beep;
			end
			break;
		end
		pause(0.001);
	end
>>>>>>> respond to buttons pressed + indents
end

%% END OF PROGRAM
disp(highToc);
disp(car1);
disp(car2);

terminate(1);
terminate(2);

matlabclient(3);

%% DISPLAY GRAPHS

if car1.running == true
	graphs(car1.lap_times, ref_time, car1.seg_times, 1);
end


if car2.running == true
	graphs(car2.lap_times, ref_time, car2.seg_times, 2);
end
