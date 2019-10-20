%% INIT
% TODO init display

disp('Startar bilbanan. Avsluta med q.')
hf=figure('position',[0 0 eps eps],'menubar','none');

initialize_counters(1)
initialize_counters(2)

config_IOs

start_race(1)
start_race(2)

car1 = struct;
car1.segment = 1;
car1.lap = 0;
car1.lap_times = [];
car1.seg_times = [];

car2 = struct;
car2.segment = 1;
car2.lap = 0;
car2.lap_times = [];
car2.seg_times = [];

tocs = [];

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
    [car1.new_lap, car1.new_check_point, car1.time] = get_car_position(1);
    [car2.new_lap, car2.new_check_point, car2.time] = get_car_position(2);
    
    %% CHECK LAP AND CHECKPOINT (CAR 1)
    if car1.new_check_point == true
        % beep;
        if car1.lap ~= 0
            car1.seg_times(car1.lap, car1.segment) = toc(car1.seg_tic);
        end
        car1.segment = car1.segment + 1;
        car1.seg_tic = tic;
    elseif car1.new_lap == true
        % beep;
        if car1.lap == 0
            % dont save time for first lap
            car1.segment = 1;
            car1.lap = car1.lap + 1;
            car1.seg_tic = tic;
            car1.lap_tic = tic;
            continue;
        end
        car1.seg_times(car1.lap, car1.segment) = toc(car1.seg_tic);
        car1.seg_tic = tic;
        car1.lap_times(car1.lap) = toc(car1.lap_tic);
        car1.lap_tic = tic;
        car1.segment = 1;
        car1.lap = car1.lap + 1;
    end
    
    %% CHECK LAP AND CHECKPOINT (CAR 2)
    if car2.new_check_point == true
        % beep;
        if car2.lap ~= 0
            car2.seg_times(car2.lap, car2.segment) = toc(car2.seg_tic);
        end
        car2.segment = car2.segment + 1;
        car2.seg_tic = tic;
    elseif car2.new_lap == true
        beep;
        if car2.lap == 0
            % dont save time for first lap
            car2.segment = 1;
            car2.lap = car2.lap + 1;
            car2.seg_tic = tic;
            car2.lap_tic = tic;
            continue;
        end
        car2.seg_times(car2.lap, car2.segment) = toc(car2.seg_tic);
        car2.seg_tic = tic;
        car2.lap_times(car2.lap) = toc(car2.lap_tic);
        car2.lap_tic = tic;
        car2.segment = 1;
        car2.lap = car2.lap + 1;
    end
    
    %% CALCULATE (CAR 1)
    car1.car_constant = get_car_constant(1);
    car1.v = get_new_v(car1.segment);
    car1.track_u_constant = get_track_u_constant();
    car1.u = get_new_u(car1.v, car1.car_constant, car1.track_u_constant);
    
    %% CALCULATE (CAR 2)
    car2.car_constant = get_car_constant(2);
    car2.v = get_new_v(car2.segment);
    car2.track_u_constant = get_track_u_constant();
    car2.u = get_new_u(car2.v, car2.car_constant, car2.track_u_constant);
    
    %% EXECUTE
    set_car_speed(1, car1.u);
    set_car_speed(2, car2.u);
    
    %% DISPLAY
    
    %% END OF LOOP
    pause(0.1)
    tocs(end + 1) = toc;
end

%% END OF PROGRAM
disp(tocs);
disp(car1);
disp(car2);

terminate(1);
terminate(2);
% TODO terminate display