function [ car_constant ] = get_car_constant( in_pos, pos )
%GET_CAR_CONSTANT Summary of this function goes here
%   Detailed explanation goes here

%{
GET_CAR_CONSTANT:
car_constant: P�verkar new_u s� att new_u tillsammans med track_u_constant motsvarar den hastighet som
anges av new_v. car_constant �ndras endast vid ny indata, vilket inneb�r att den �r konstant under resterande
cykler fram tills n�sta givare passeras. Genom att j�mf�ra positionen som f�s av givarna med indatan kan programmet
r�kna ut felmarginalen som har uppst�tt och kalibrera car_constant new_u kan justeras med st�rre
precision.
%}

switch(in_pos)
    case 1
        car_constant = 0.95;
    case 2
        car_constant = 1.0;
end
end

