function [ car ] = do_gov( car )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if car.new_check_point
    status = car.forecasts(car.lap, car.segment-1)/car.ref_time;
    car.constant = car.constant + (status - 1) * 0.01;
    disp(car.constant);
end

