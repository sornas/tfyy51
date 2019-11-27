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
        car.constant = car.constant * 1.2;
        disp('###')
        disp(car.num)
        disp(car.constant)
    end
    %% First segment
    if car.lap == 1 && car.segment == 1 || car.lap == 1 && car.segment == 2
        t = toc(boot.time);
        if t > 0.8
            car.constant = car.constant + 0.04;
            disp('###')
            disp(car.num)
            disp(car.constant)
            boot.time = tic;
        end
        
    end
 % ide höj carconstant så att den blir mer aggresivare ju längre tid som går t.ex efter 3.5 s   
 %    if car.lap == 1 && car.segment == 1 || car.lap == 1 && car.segment == 2
 %        t = toc(boot.time);
 %        if t > 1.0
 %            car.constant = car.constant + 0.5;
 %            disp('###')
 %            disp(car.num)
 %            disp(car.constant)
 %            boot.time = tic;
 %        end
 %        
 %    end    
    
    %% END BOOTSTRAP
    if car.segment > 3
        disp(car.constant);
        seg_time = car.seg_times(1, 3);
        laptime_forecast = seg_time / 0.102;
        forecast_ref_diff = laptime_forecast - car.ref_time;
        forecast_ref_diff_rel = forecast_ref_diff / car.ref_time;
        car.constant = car.constant + (forecast_ref_diff_rel * 0.15);
        % car.constant = car.constant * 1.05;  % kompensation för kall bana
        boot.status = 0;
        disp('END OF BOOTSTRAP')
        disp(car.num)
        disp(car.constant)
    end
end
end