function [ new_v ] = get_new_v( old_v, speed_constant, target_diff, car_position_diff, agressiveness )
%GET_NEW_V Hastigheten som bilen ska f� n�sta cykel.
%{
Utg�r ifr�n position och ger motsvarande h�rdkodade v�rde p� v f�r
nuvarande sub_segment.
%}
position = old_v*100; %temp input f�r position
list = speed_constant; %temp input f�r listan Bana1
for i = 1:length(list)
    
    if position > 1960
        new_v = list(length(list),4);
    
    elseif list(i,1) > position
        new_v = list((i-1),4);
        break
    end    
    
end
end
