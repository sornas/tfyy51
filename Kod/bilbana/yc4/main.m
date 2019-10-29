%% INIT
% INIT DISPLAY
addpath display/ClientServerApp/Release
cd display/ClientServerApp/Release
!startServer
cd ../../..

global display_data;
display_data = {};
display_data = {display_data clear_display()};
pause(1);

disp('Startar bilbanan. Avsluta med q.')
hf=figure('position',[0 0 eps eps],'menubar','none');

initialize_counters(1)
initialize_counters(2)

config_IOs

start_race(1)
start_race(2)

car1 = struct;
car1.running = false;
car1.automatic = true;
car1.segment = 1;
car1.lap = 0;
car1.lap_times = [];
car1.seg_times = [];

car2 = struct;
car2.running = false;
car2.automatic = true;
car2.segment = 1;
car2.lap = 0;
car2.lap_times = [];
car2.seg_times = [];

tocs = [];

%% ASK ACTIVE CARS
disp('J = Ja (automatiskt), M = Ja (manuellt), N = Nej');

car1.response = input('Vill du köra bil 1? [N]', 's');
if car1.response == 'J'
	car1.running = true;
	car1.automatic = true;
elseif car1.response == 'M'
	car1.running = true;
	car1.automatic = false;
else
	car1.running = false;
end

car2.response = input('Vill du köra bil 2? [N]', 's');
if car2.response == 'J'
	car2.running = true;
	car2.automatic = true;
elseif car2.response == 'M'
	car2.running = true;
	car2.automatic = false;
else
	car2.running = false;
end


%% MAIN LOOP
while 1
    tic;
    %% PRE-LOOP
    if strcmp(get(hf,'currentcharacter'),'q')
        close(hf)
        break
    end
    
    figure(hf)
    drawnow
    
    %% READ
    if car1.running == true
		[car1.new_lap, car1.new_check_point, car1.time] = get_car_position(1);
    end
	if car2.running == true
		[car2.new_lap, car2.new_check_point, car2.time] = get_car_position(2);
	end
    
    %% CHECK LAP AND CHECKPOINT (CAR 1)
	if car1.running == true
			if car1.new_check_point == true
				% beep;
				if car1.lap ~= 0
					car1.seg_times(car1.lap, car1.segment) = toc(car1.seg_tic);
				end
				car1.segment = car1.segment + 1;
				car1.seg_tic = tic;
			end
			if car1.new_lap == true
				if car1.lap == 0
					% dont save time for first lap
					car1.segment = 1;
					car1.lap = car1.lap + 1;
					car1.seg_tic = tic;
					car1.lap_tic = tic;
					continue;
				end
				beep;
				car1.seg_times(car1.lap, car1.segment) = toc(car1.seg_tic);
				car1.seg_tic = tic;
				car1.lap_times(car1.lap) = toc(car1.lap_tic);
				car1.lap_tic = tic;

				display_data = {display_data, put_text(100, 32, 'L', strjoin({num2str(car1.lap), get_time_as_string(round(car1.lap_times(car1.lap) * 1000))}, ' '))};
				
				car1.segment = 1;
				car1.lap = car1.lap + 1;
				
				car1.seg_times(car1.lap, 1) = 0;
			end
	end

    %% CHECK LAP AND CHECKPOINT (CAR 2)
	if car2.running == true
		if car2.new_check_point == true
			% beep;
			if car2.lap ~= 0
				car2.seg_times(car2.lap, car2.segment) = toc(car2.seg_tic);
			end
			car2.segment = car2.segment + 1;
			car2.seg_tic = tic;
		end
		if car2.new_lap == true
			if car2.lap == 0
				% dont save time for first lap
				car2.segment = 1;
				car2.lap = car2.lap + 1;
				car2.seg_tic = tic;
				car2.lap_tic = tic;
				disp('continuing');
				continue;
			end
			beep;
			
			car2.seg_times(car2.lap, car2.segment) = toc(car2.seg_tic);
			car2.seg_tic = tic;
			car2.lap_times(car2.lap) = toc(car2.lap_tic);
			car2.lap_tic = tic;

			display_data = {display_data, put_text(100, 48, 'L', strjoin({num2str(car2.lap), get_time_as_string(round(car2.lap_times(car2.lap) * 1000))}, ' '))};
				
			car2.segment = 1;
			car2.lap = car2.lap + 1;
			
			car2.seg_times(car2.lap, 1) = 0;
		end
	end

	%% CALCULATE (CAR 2)
	if car1.running == true & car1.automatic == true
		car1.car_constant = get_car_constant(1);
		car1.v = get_new_v(car1.segment);
		car1.track_u_constant = get_track_u_constant();
		car1.u = get_new_u(car1.v, car1.car_constant, car1.track_u_constant);
	end
    
    %% CALCULATE (CAR 2)
	if car2.running == true & car2.automatic == true
		car2.car_constant = get_car_constant(2);
		car2.v = get_new_v(car2.segment);
		car2.track_u_constant = get_track_u_constant();
		car2.u = get_new_u(car2.v, car2.car_constant, car2.track_u_constant);
	end
    
	%% CONTROLLER (CAR 1)
	if car1.running == true & car1.automatic == false
		% TODO
	end

	%% CONTROLLER (CAR 2)
	if car2.running == true & car2.automatic == false
		% TODO
	end


    %% EXECUTE
    if car1.running == true & car1.automatic == true
		set_car_speed(1, car1.u);
	end
	if car2.running == true & car2.automatic == true
   		set_car_speed(2, car2.u);
	end
    %% DISPLAY
    
    %% END OF LOOP
    pause(0.1)
    tocs(end + 1) = toc;
    send_data_to_display();
end
 
%% END OF PROGRAM
disp(tocs);
disp(car1);
disp(car2);

terminate(1);
terminate(2);

matlabclient(3);

%% DISPLAY GRAPHS

if car1.running == true
	graphs(car1.lap_times, 13, car1.seg_times, 1);
end
if car2.running == true
	graphs(car2.lap_times, 13, car2.seg_times, 2);
end
