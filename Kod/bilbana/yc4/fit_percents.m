function [ new_percents ] = fit_percents( percents, lap_time, seg_times )
%FIT_PERCENTS Summary of this function goes here
%   Detailed explanation goes here
new_percents = [];
for i = 1:length(percents)
    old_p = percents(i);
    cur_p = seg_times(i) / lap_time;
    new_p = old_p - (old_p + cur_p) / 2;
    new_percents(i) = new_p;
end
new_percents = new_percents * (1/sum(new_percents))  % normera
