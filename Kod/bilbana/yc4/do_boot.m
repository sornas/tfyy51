function [car, boot] = do_boot(car, boot)
%BOOT Summary of this function goes here
%   Detailed explanation goes here
if car.running == true
    %% BEFORE FIRST LAP
    if car.lap == 0
        t = toc(boot.time);
        if t > 1
            car.constant = car.constant + 0.05;
            disp(car.constant)
            boot.time = tic;
        end
    end
end
end