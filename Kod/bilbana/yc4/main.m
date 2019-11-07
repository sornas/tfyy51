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

load('bilbana\files\Bana1.mat')
load('bilbana\files\Bana2.mat')

start_race(1)
% start_race(2)

car1 = struct;
car1.running = false;
car1.automatic = true;
car1.segment = 1;
car1.lap = 0;
car1.lap_times = [];
car1.seg_times = [];
car1.position = 0;
car1.seg_len = [0.0 2.53 3.05 4.73 7.68 8.98 10.93 14.69 17.57];


car2 = struct;
car2.running = false;
car2.automatic = true;
car2.segment = 1;
car2.lap = 0;
car2.lap_times = [];
car2.seg_times = [];
car2.position = 0;
car2.seg_len = [0.0 2.53 3.05 4.92 7.60 8.84 10.65 14.68 17.76];


highToc = 0;

%% ASK ACTIVE CARS
disp('J = Ja (automatiskt), M = Ja (manuellt), N = Nej');

car1.response = input('Vill du köra bil 1? [N] ', 's');
if car1.response == 'J'
	car1.running = true;
	car1.automatic = true;
elseif car1.response == 'M'
	car1.running = true;
	car1.automatic = false;
else
	car1.running = false;
end


car2.response = input('Vill du köra bil 2? [N] ', 's');
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
    readTime = tic;
    %% PRE-LOOP
    if strcmp(get(hf,'currentcharacter'),'q')
        close(hf)
        break
    end
    
    figure(hf)
    drawnow
    % disp(car1);
    
    %% READ
    if car1.running == true
		[car1.new_lap, car1.new_check_point, car1.time] = get_car_position(1);
    end
	
    if car2.running == true
		[car2.new_lap, car2.new_check_point, car2.time] = get_car_position(2);
    end
    
    
    %% CHECK LAP AND CHECKPOINT (CAR 1)
    if car1.running == true
        
        %% CALC POSITION (CAR 1)
        if car1.lap > 1
            last_seg_times1 = car1.seg_times(car1.lap - 1, 1:9);
            aprox_v = get_aprox_v(car1.segment, last_seg_times1);
            car1.position = get_position(aprox_v, car1.position, t);
        end
        if car1.new_check_point == true
            % beep;
            if car1.lap ~= 0
                car1.seg_times(car1.lap, car1.segment) = toc(car1.seg_tic);
            end
            car1.segment = car1.segment + 1;
            car1.seg_tic = tic;
            car1.position = car1.seg_len(car1.segment);
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
            car1.position = 0;

            display_data = {display_data, put_text(100, 32, 'L', strjoin({num2str(car1.lap), get_time_as_string(round(car1.lap_times(car1.lap) * 1000))}, ' '))};

            car1.segment = 1;
            car1.lap = car1.lap + 1;
        end
    end

    
    
    %% CHECK LAP AND CHECKPOINT (CAR 2)
    if car2.running == true
        
        %% CALC POSITION (CAR 2
       if car2.lap > 1
           last_seg_times2 = car2.seg_times(car2.lap - 1, 1:9);
           aprox_v = get_aprox_v(car2.segment, last_seg_times2);
           car2.position = get_position(aprox_v, car2.position, t);
       end
        if car2.new_check_point == true
            % beep;
            if car2.lap ~= 0
                car2.seg_times(car2.lap, car2.segment) = toc(car2.seg_tic);
            end
            car2.segment = car2.segment + 1;
            car2.seg_tic = tic;
            car2.position = car2.seg_len(car2.segment);
        end
        if car2.new_lap == true
            if car2.lap == 0
                % dont save time for first lap
                car2.segment = 1;
                car2.lap = car2.lap + 1;
                car2.seg_tic = tic;
                car2.lap_tic = tic;
                continue;
            end
            beep;
            car2.seg_times(car2.lap, car2.segment) = toc(car2.seg_tic);
            car2.seg_tic = tic;
            car2.lap_times(car2.lap) = toc(car2.lap_tic);
            car2.lap_tic = tic;
            car2.position = 0;

            display_data = {display_data, put_text(100, 32, 'L', strjoin({num2str(car2.lap), get_time_as_string(round(car2.lap_times(car2.lap) * 1000))}, ' '))};

            car2.segment = 1;
            car2.lap = car2.lap + 1;
        end
    end
    

	%% CALCULATE (CAR 1)
    if car1.running == true && car1.automatic == true
		car1.car_constant = get_car_constant(1);
		car1.v = get_new_v(car1.position, Bana1);
		car1.track_u_constant = get_track_u_constant();
		car1.u = get_new_u(car1.v, car1.car_constant, car1.track_u_constant);
    end
    
    
    %% CALCULATE (CAR 2)
	if car2.running == true && car2.automatic == true
		car2.car_constant = get_car_constant(2);
		car2.v = get_new_v(car2.position, Bana2);
		car2.track_u_constant = get_track_u_constant();
		car2.u = get_new_u(car2.v, car2.car_constant, car2.track_u_constant);
	end
    
    
	% TEMP VARIABLES FOR MANUAL CONTROL
	mult = 100;
	max = 55;
	div = 55;

	%% CONTROLLER (CAR 1)
	if car1.running == true && car1.automatic == false
		set_car_speed(1, mult * ((max - get_manual_speed(1)) / div));
	end

	
	%% CONTROLLER (CAR 2)
	if car2.running == true && car2.automatic == false
		set_car_speed(2, mult * ((max - get_manual_speed(2)) / div));
	end
    

    %% EXECUTE
    if car1.running == true && car1.automatic == true
		set_car_speed(1, car1.u);
    end
    
    
    if car2.running == true && car2.automatic == true
   		set_car_speed(2, car2.u);
    end
    
    
    %% DISPLAY
    
    %% END OF LOOP
    while 1                     %Whileloop med paus som k�rs till pausen �verskridit 0.07 sekunder
        pause(0.001);
        t = toc(readTime);
        if t > 0.07
            if t > highToc
                highToc = t;     %Om det nya v�rdet p� pausen �r h�gre �n den tidigare h�gsta s� sparas det som den h�gsta
            end
            if t > 0.1
                beep;
            end
            break;
        end
    end
   
    send_data_to_display();
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
	graphs(car1.lap_times, 13.00, car1.seg_times, 1);
end


if car2.running == true
	graphs(car2.lap_times, 13, car2.seg_times, 2);
end