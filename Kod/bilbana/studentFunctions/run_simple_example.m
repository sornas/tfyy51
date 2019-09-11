%% ---------------- Do not touch ---------------- %
disp('Startar bilbanan. Avsluta med q')
hf=figure('position',[0 0 eps eps],'menubar','none');
% ----------------------------------------------- %
%% User input
track_number = 1;
car = init_car(track_number); 

%% Init race track
initialize_counters(car.track_number)
config_IOs
start_race(car.track_number)

%% Start cars
start_control = 29; % 29 works for the white castrol car marked with number 82
car = update_control(start_control, car);

%% Running loop
while 1
    
    % ---------------- Do not touch ---------------- %
    % Check if user has pressed q
    if strcmp(get(hf,'currentcharacter'),'q')
        close(hf)
        break
    end
    % force the event queue to flush
    figure(hf)
    drawnow
    % ---------------------------------------------- %
    
    car = car_controller(car);
    
    pause(0.1) % Pause 0.1 s
end

terminate(1)
terminate(2)

% run file to plot results
plot_results();