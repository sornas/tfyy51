function [ position ] = get_position( aprox_v, prev_p, delta_t)
%GET_POSITION: Uppskattar position utifr�n f�rra positionen och hastigheten
%{   
Anv�nder s = v*t f�r att ber�kna skillnaden i strecka sedan f�rra cykeln.
v �r just nu medelhastigheten f�r nuvarande segment f�rra cykeln.
dt �r just nu samma tic toc som checkar att cykeln inte var mer �n 0.1 s.
%}
v = aprox_v;
dt = delta_t;
dp = v*dt;
position = prev_p + dp;
end

