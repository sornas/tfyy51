function [ car ] = do_gov( car )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if car.new_lap && car.lap > 1 % annars höjer den typ alltid första varvet
	last_lap_time = car.lap_times(car.lap - 1);
	time_diff = last_lap_time - car.ref_time;  % diff >0 => car is too slow, go faster
	car.constant = car.constant + (time_diff / car.ref_time) * 0.1;
elseif car.new_check_point && (car.segment == 5 || car.segment == 8)
	if car.lap == 1
		status = car.forecasts_naive(car.lap, car.segment-1)/car.ref_time;
	else
		status = car.forecasts(car.lap, car.segment-1)/car.ref_time;
	end
	car.constant = car.constant + (status - 1) * 0.08;
	car.governs(length(car.governs) + 1) = car.constant;
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

