function [ new_v ] = get_new_v( old_v, speed_constant, target_diff, car_position_diff, agressiveness )
%GET_NEW_V Hastigheten som bilen ska få nästa cykel.
%{
Utgår ifrån position och ger motsvarande hårdkodade värde på v för
nuvarande sub_segment.
%}
position = old_v*100; %temp input för position
list = speed_constant; %temp input för listan Bana1
for i = 1:length(list)
    
    if position > 1960
        new_v = list(length(list),4);
    
    elseif list(i,1) > position
        new_v = list((i-1),4);
        break
    end    
    
end
end
