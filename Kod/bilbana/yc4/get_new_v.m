function [ new_v ] = get_new_v( position, list)
%GET_NEW_V Hastighetsparametern som bilen ska f� n�sta cykel.
%{
Utg�r ifr�n position och ger motsvarande h�rdkodade v�rde p� v f�r
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
      
