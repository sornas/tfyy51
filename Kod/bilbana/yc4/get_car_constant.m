function [ car_constant ] = get_car_constant( in_pos, pos )
%GET_CAR_CONSTANT Summary of this function goes here
%   Detailed explanation goes here
    switch(in_pos)
        case 1
            car_constant = 1;
        case 2
            car_constant = 1.2; 
    end
    return
end

