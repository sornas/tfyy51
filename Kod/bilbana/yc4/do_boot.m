function [car] = do_boot(car, boot_time)
%BOOT Summary of this function goes here
%   Detailed explanation goes here
if car.running == true
    [car.new_lap, car.new_check_point, car.time] = get_car_position(car.num);
    %% CHECK POINT
    if car.new_check_point == true
        if car.new_lap == false % choose_position krachar vid nytt varv (seg 10)
            if car.lap ~= 0
                car.seg_times(car.lap, car.segment) = toc(car.seg_tic);
                car.seg_constant_list(car.lap, car.segment) = car.seg_constant;
            end
            car.segment = car.segment + 1;
            car.seg_tic = tic;
            if car.lap > 2 % Sï¿½kerhetsmarginal (Bï¿½r vara 1?)
                disp(car)
                [new_position, seg_plus] = ...
                    choose_position(car.position, car.segment, car.num, car.pos_at);
                if seg_plus ~= 0 && car.segment == 2
                    disp('Hoppar ï¿½ver missad givare 1/2');
                else
                    car.position = new_position;
                    car.segment = car.segment + seg_plus;
                end
                if seg_plus ~= 0
                    car.seg_times(car.lap, car.segment - seg_plus - 1) = 0;
                    car.seg_constant_list(car.lap, car.segment - seg_plus - 1) = 0;
                    disp(car.seg_times(car.lap, :))
                    disp(seg_plus)
                end
                %car.miss_time = uint64(0);
            else
                car.position = car.pos_at(car.segment);
                %car.miss_time = uint64(0);
            end
        end
    end
    %% NEW LAP
    if car.new_lap == true
        car.lap_constants = gov_set(car.constant);
        car.new_lap = false; %TODO remove
        beep;
        if car.lap == 0
            % dont save time for first lap
            car.segment = 1;
            car.lap = car.lap + 1;
            car.seg_tic = tic;
            car.lap_tic = tic;
        else
            % beep;
            % Spara inte seg_time om missad givare
            if car.segment == 9
                car.seg_times(car.lap, car.segment) = toc(car.seg_tic);
                car.seg_constant_list(car.lap, car.segment) = car.seg_constant;
            end
            car.seg_tic = tic;
            car.lap_times(car.lap) = toc(car.lap_tic);
            car.lap_tic = tic;
            car.position = 0;

            if car.lap == 1 && size(car.seg_times, 2) < 9
                disp('FEL: För få segment!!')
                car.stopped = true;
                other_car.stopped = true;
                return
            end

            display_data = [display_data, put_text(100, 16 + (16 * car.num), 'L', strjoin({num2str(car.lap), get_time_as_string(round(car.lap_times(car.lap) * 1000))}, ' '))];

            car.segment = 1;
            car.lap = car.lap + 1;
        end
    end
    %% CALCULATE
    if car.running == true && car.automatic == true
        car.v = get_new_v(car.position, car.map);
        car.seg_constant = get_seg_constant(car.position, car.lap_constants, car.num, car.pos_at);
        car.u = get_new_u(car.v, car.seg_constant);
    end
    %% BEFORE FIRST LAP
    if car.lap == 0
        t = toc(boot_time);
        if t > 1
            car.constant = car.constant + 0.05;
            boot_time = tic;
        end
    end
end
end