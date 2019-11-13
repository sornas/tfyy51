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
hf=figure('position', [0 0 eps eps], 'menubar', 'none');

initialize_counters(1)
initialize_counters(2)


config_IOs

load('bilbana\files\Bana1.mat')
load('bilbana\files\Bana2.mat')

start_race(1)
start_race(2)

car1 = struct;
car1.running = false;
car1.automatic = true;
car1.segment = 1;
car1.lap = 0;
car1.lap_times = [];
car1.seg_times = [];
car1.last_seg_times = [];
car1.position = 0;
car1.seg_len = [0.0 2.53 3.05 4.73 7.68 8.98 10.93 14.69 17.57];
car1.map = Bana1;
car1.approximation = [];
car1.miss_probability = 0.0;


car2 = struct;
car2.running = false;
car2.automatic = true;
car2.segment = 1;
car2.lap = 0;
car2.lap_times = [];
car2.seg_times = [];
car2.last_seg_times = [];
car2.position = 0;
car2.seg_len = [0.0 2.53 3.05 4.92 7.60 8.84 10.65 14.68 17.76];
car2.map = Bana2;
car2.miss_probability = 0.0;


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
    
	[car1, car1.stop] = do_car(car1);
	[car2, car2.stop] = do_car(car2);

	if car1.stop == truej
		disp('stopped by car 1');
		break;
	end
	if car2.stop == true
		disp('stopped by car 2');
		break;
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
                % beep;
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
	graphs(car1.lap_times, 13, car1.seg_times, 1);
end


if car2.running == true
	graphs(car2.lap_times, 13, car2.seg_times, 2);
end
