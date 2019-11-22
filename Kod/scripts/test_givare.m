disp('Startar bilbanan. Avsluta med q.')
hf=figure('position',[0 0 eps eps],'menubar','none');

initialize_counters(1)
initialize_counters(2)

start_race(1)
start_race(2)

config_IOs

car1 = struct;
car2 = struct;    

while 1
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
    
    if car1.new_lap || car1.new_check_point == true || car2.new_lap == true || car2.new_check_point == true
       disp('###')
    end
    
    if car1.new_check_point
        beep;
        disp('car 1 cp')
    end
    if car2.new_check_point
        beep;
        disp('car 2 cp')
    end
    if car1.new_lap
        beep;
        disp('car 1 lap')
    end
    if car1.new_lap
        beep;
        disp('car 2 lap')
    end
    pause(0.1)
end

%%
terminate(1)
terminate(2)