function [ new_v ] = get_new_v( old_v, speed_constant, target_diff, car_position_diff, agressiveness )
%GET_NEW_V Hastigheten som bilen ska få nästa cykel.
%{
Tar förra cykelns hastighet (old_ v) och lägger till eller drar
av beroende på hur långt ifrån målet bilarna ligger (target_diff) och, 
om gemensam målgång är aktiverad, hur långt ifrån varandra bilarna är 
(car_position_diff). Beror också på agressiveness; högre agressiveness ger 
större skillnad mellan new_v och old_v medan ett lågt värde gör att new_v 
inte ändras särskilt mycket. new_v används sedan för att sätta new_u. 
Högre new_v ger högre new_u och lägre new_v ger lägre_u. 
%}

%{
GET_NEW_V:
new_v: Den hastighet som bilen ska få nästa cykel. 
%}

v = [35, 25, 30, 30, 40, 50, 45, 50, 35];
new_v = v(old_v);
end

