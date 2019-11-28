function [ car ] = do_gov( car )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if car.new_lap
    % TODO calculate stuff
elseif car.new_check_point && (car.segment == 5 || car.segment == 8)
    if true %car.lap == 1
        status = car.forecasts(car.lap, car.segment-1)/car.ref_time;
        car.constant = car.constant + (status - 1) * 0.08;
        car.governs(length(car.governs) + 1) = car.constant;
    end
    %{
    if car.lap > 1 && (car.segment == 5 || car.segment == 8)
        car.lap_now = toc(car.lap_tic);
        norm_const = 1/(sum(car.percents(1:9)));
        norm_list = car.percents * norm_const;
        sum_percent = sum(norm_list(1:car.segment));
        exp_time = car.ref_time * sum_percent;
        
        status = car.lap_now/exp_time;
        car.constant = car.constant + (status - 1) * 0.08;
        car.governs(length(car.governs) + 1) = car.constant;
    end
    %}
end

