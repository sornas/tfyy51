function [ new_u ] = get_new_u( new_v, car_constant, track_u_constant )
%GET_NEW_U Summary of this function goes here
%   Detailed explanation goes here

%{
GET_NEW_U: 
new_u: Den spänning som ska appliceras beroende på vilken hastighet new_v anger. Ett högre new_v innebär
ett högre new_u. De andra parametrarna som påverkar new_u är car_constant och track_u_constant, desto högre
dessa värden dessa antar desto högre värde antar också new_u. new_u är programmets sista output, dess värde
0 till 127 är det gaspådrag som appliceras på bilen.
%}
new_u = new_v*car_constant*track_u_constant;
end

