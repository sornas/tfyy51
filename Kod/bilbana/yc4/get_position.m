function [ position ] = get_position( aprox_v, prev_p, delta_t)
%GET_POSITION: Uppskattar position utifrån förra positionen och hastigheten
%{   
Använder s = v*t för att beräkna skillnaden i strecka sedan förra cykeln.
v är just nu medelhastigheten för nuvarande segment förra cykeln.
dt är just nu samma tic toc som checkar att cykeln inte var mer än 0.1 s.
%}
v = aprox_v;
dt = delta_t;
dp = v*dt;
position = prev_p + dp;
end

