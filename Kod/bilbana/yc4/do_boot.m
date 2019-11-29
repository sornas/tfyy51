function [car, boot] = do_boot(car, boot)
%BOOT Summary of this function goes here
%   Detailed explanation goes here
if car.running == true
    %% BEFORE FIRST LAP
    if car.lap == 0
        t = toc(boot.time);
        if t > 0.7
            car.constant = car.constant + 0.12;
            % disp('###')
            % disp(car.num)
            % disp(car.constant)
            boot.time = tic;
        end
    end
    %% WHEN NEW LAP
    if car.new_lap == 1
        car.constant = car.constant + 0.2;
        % disp('###')
        % disp(car.num)
        % disp(car.constant)
    end
    %% First segments
    if car.lap == 1 && car.segment == 1 || car.lap == 1 && car.segment == 2
        t = toc(boot.time);
        if t > 1.2
            if car.num == 1
                car.constant = car.constant + 0.06;
            else
                car.constant = car.constant + 0.04;
            end
            % disp('###')
            % disp(car.num)
            % disp(car.constant)
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
 %    end    
    
    %% END BOOTSTRAP
    if car.segment > 3
        car.governs(length(car.governs) + 1) = car.constant;
        % disp(car.constant);
        status = car.forecasts_naive(car.lap, car.segment-1) / 15;
        car.constant = car.constant + (status - 1) * 0.08;
        
        boot.status = 0;
        % disp('END OF BOOTSTRAP')
        % disp(car.num)
        % disp(car.constant)
        car.governs(length(car.governs) + 1) = car.constant;
    end
end
end