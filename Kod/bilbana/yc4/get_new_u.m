function [ new_u ] = get_new_u( new_v, car_constant, track_u_constant )
%GET_NEW_U Summary of this function goes here
%   Detailed explanation goes here

%{
GET_NEW_U: 
new_u: Den sp�nning som ska appliceras beroende p� vilken hastighet new_v anger. Ett h�gre new_v inneb�r
ett h�gre new_u. De andra parametrarna som p�verkar new_u �r car_constant och track_u_constant, desto h�gre
dessa v�rden dessa antar desto h�gre v�rde antar ocks� new_u. new_u �r programmets sista output, dess v�rde
0 till 127 �r det gasp�drag som appliceras p� bilen.
%}
new_u = new_v*car_constant*track_u_constant;
end

