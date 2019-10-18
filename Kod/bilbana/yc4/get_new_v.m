function [ new_v ] = get_new_v( old_v, speed_constant, target_diff, car_position_diff, agressiveness )
%GET_NEW_V Hastigheten som bilen ska f� n�sta cykel.
%{
Tar f�rra cykelns hastighet (old_ v) och l�gger till eller drar
av beroende p� hur l�ngt ifr�n m�let bilarna ligger (target_diff) och, 
om gemensam m�lg�ng �r aktiverad, hur l�ngt ifr�n varandra bilarna �r 
(car_position_diff). Beror ocks� p� agressiveness; h�gre agressiveness ger 
st�rre skillnad mellan new_v och old_v medan ett l�gt v�rde g�r att new_v 
inte �ndras s�rskilt mycket. new_v anv�nds sedan f�r att s�tta new_u. 
H�gre new_v ger h�gre new_u och l�gre new_v ger l�gre_u. 
%}

%{
GET_NEW_V:
new_v: Den hastighet som bilen ska f� n�sta cykel. 
%}

v = [35, 25, 30, 30, 40, 50, 45, 50, 35];
new_v = v(old_v);
end

