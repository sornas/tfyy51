function [ seg_times ] = format_seg_times( car )
%FORMAT_POST_RACE_DATA Summary of this function goes here
%   Detailed explanation goes here
seg_times = [];
disp(car.seg_times)
if car.running
    for x = 1:size(car.seg_times, 2)
        s = 0;
        amount = 0;
        for y = 1:size(car.seg_times, 1)
            if car.seg_times(y, x) ~= 0
                s = s + car.seg_times(y, x);
                amount = amount + 1;
            end
        end
        seg_times(x) = s / amount;
    end
end
end

