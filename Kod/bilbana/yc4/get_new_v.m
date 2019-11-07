function [ new_v ] = get_new_v( position, list)
%GET_NEW_V Hastigheten som bilen ska få nästa cykel.
%{
Utgår ifrån position och ger motsvarande hårdkodade värde på v för
nuvarande sub_segment.
%}
position = position*100; %temp input för position



for i = 1:length(list)
    
    if list(i,1) > position
        new_v = list((i-1),4);
        break
    end    
    elseif i == 80
        new_v = list(80,4);
end       
end
