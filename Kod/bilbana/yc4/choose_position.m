function [new_position, seg_plus] = choose_position(position,segment,t_missed, track)
%CHOOSE_POSITION V�lj vad position ska vara
%   K�r endast vid ny indata. Kollar om indatan �r rimlig eller om n�gon 
%   givare missats. Sedan v�ljs position efter vilken givare det var som 
%   passerades. seg_plus anger om och med hur mycket car.segment b�r
%   justeras f�r att kompensera efter missad givare.
track_len = [19.60 2.53 3.05 4.73 7.68 8.98 10.93 14.96 17.57;
             0 0 0 0 0 0 0 0 0];
set_pos = [0 2.53 3.05 4.73 7.68 8.98 10.93 14.96 17.57;
            0 0 0 0 0 0 0 0 0];
pos_c = position;
pos_i = track_len( track, segment);
%% Vilken givare ligger n�rmast pos_c?
near = [];
for i = 1:length(track_len)
    diff = abs(track_len(track,i)-pos_c);
    if i == 1
        near = [i,diff];
    else
        if diff < near(i)
            near = [i,diff];
        end
    end
end
%% Ber�kning av passerad givare
if near(1) == segment
    new_position = set_pos( track, segment);
    seg_plus = 0;
else
    seg_plus = near(1) - segment
    new_position = set_pos( track, segment)
end
% TODO B�ttre att utg� ifr�n ingen missad givare ifall ingen annan givare
% �r s�rskillt n�ra pos_c heller. (�ven om det �r n�rmare)
end

