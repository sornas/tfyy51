function [car, boot] = do_boot(car, boot)
%BOOT Summary of this function goes here
%   Detailed explanation goes here
if car.running == true
    %% BEFORE FIRST LAP
    if car.lap == 0
        t = toc(boot.time);
        if t > 0.6
            car.constant = car.constant + 0.12;
            disp('###')
            disp(car.num)
            disp(car.constant)
            boot.time = tic;
        end
    end
    %% WHEN NEW LAP
    if car.new_lap == 1
        car.constant = car.constant + 0.3;
        disp('###')
        disp(car.num)
        disp(car.constant)
    end
    %% First segment
    if car.lap == 1 && car.segment == 1 || car.lap == 1 && car.segment == 2
        t = toc(boot.time);
        if t > 0.8
            car.constant = car.constant + 0.05;
            disp('###')
            disp(car.num)
            disp(car.constant)
            boot.time = tic;
        end
    end
    
    
    
    %% END BOOTSTRAP
    if car.segment > 2
        boot.status = 0;
        disp('END OF BOOTSTRAP')
        disp(car.num)
        disp(car.constant)
    end
end
end