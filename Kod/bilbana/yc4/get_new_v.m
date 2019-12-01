function [ new_v ] = get_new_v( position, list)
%GET_NEW_V Hastighetsparametern som bilen ska få nästa cykel.
%{
Utgår ifrån position och ger motsvarande hårdkodade värde på v för
nuvarande sub_segment.
%}
position = position*100;
for i = 1:length(list)
    if list(i,1) > position
        new_v = list((i-1),4);
        break
    elseif i == length(list)
        new_v = list(80,4);
        break
    end  
end
      
