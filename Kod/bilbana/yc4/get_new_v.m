function [ new_v ] = get_new_v( old_v, speed_constant, target_diff, car_position_diff, agressiveness )
%GET_NEW_V Summary of this function goes here
%   Detailed explanation goes here
    v = [35, 25, 30, 30, 40, 50, 45, 50, 35];
    
    new_v = v(old_v);
    
    return
end

