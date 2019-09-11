function [] = run_scalectrix()
% Runs the Scalectrix with hand controls enabled. "q" stops execution.
%
% Tobias Lindell - 2013-02-12


disp('Startar bilbanan. Avsluta med q')
hf=figure('position',[0 0 eps eps],'menubar','none');

%% Init race track
initialize_counters(1)
initialize_counters(2)

config_IOs

start_race(1)
start_race(2)

%% Running loop
while 1
%     tic
    % Check if user has pressed q
    if strcmp(get(hf,'currentcharacter'),'q')
        close(hf)
        break
    end
    % force the event queue to flush
    figure(hf)
    drawnow
    
    % Read speed from controllers and set new car speeds
    my_speed_1 = get_manual_speed(1);
    my_speed_1 = 100*((55 - my_speed_1)/55);
    set_car_speed(1,my_speed_1);
    
    my_speed_2 = get_manual_speed(2);
    my_speed_2 = 100*((55 - my_speed_2)/55);
    set_car_speed(2,my_speed_2)
%     toc
    pause(0.1) % Pause 0.1 s
end

[lap_car1,chk_pnt_car1,time] = get_car_position(1)
[lap_car2,chk_pnt_car2,time] = get_car_position(2)

terminate(1)
terminate(2)