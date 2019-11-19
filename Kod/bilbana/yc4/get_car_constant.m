function [ car_constant ] = get_car_constant( in_pos, pos )
%GET_CAR_CONSTANT Summary of this function goes here
%   Detailed explanation goes here

%{
GET_CAR_CONSTANT:
car_constant: Påverkar new_u så att new_u tillsammans med track_u_constant motsvarar den hastighet som
anges av new_v. car_constant ändras endast vid ny indata, vilket innebär att den är konstant under resterande
cykler fram tills nästa givare passeras. Genom att jämföra positionen som fås av givarna med indatan kan programmet
räkna ut felmarginalen som har uppstått och kalibrera car_constant new_u kan justeras med större
precision.
%}

switch(in_pos)
    case 1
        car_constant = 0.95;
    case 2
        car_constant = 1.0;
end
end

