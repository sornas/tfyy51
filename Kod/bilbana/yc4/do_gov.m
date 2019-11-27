function [ car ] = do_gov( car )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if car.new_lap
    % TODO calculate stuff
elseif car.new_check_point && (car.segment == 5 || car.segment == 8)
    status = car.forecasts(car.lap, car.segment-1)/car.ref_time;
    car.constant = car.constant + (status - 1) * 0.08;
    car.governs(length(car.governs) + 1) = car.constant;
end

