function [new_position, seg_plus] = choose_position(position,segment, track, track_len)
%CHOOSE_POSITION V�lj vad position ska vara
%   K�r endast vid ny indata. Kollar om indatan �r rimlig eller om n�gon 
%   givare missats. Sedan v�ljs position efter vilken givare det var som 
%   passerades. seg_plus anger om och med hur mycket car.segment b�r
%   justeras f�r att kompensera efter missad givare.
pos_c = position;
%% Vilken givare ligger n�rmast pos_c?
near = [];
for i = 1:length(track_len)
    diff = abs(track_len(i) - pos_c);
    if i == 1
        near = [i, diff];
    else
        if diff < near(2)
            near = [i, diff];
        end
    end
end
disp(near);
%% Ber�kning av passerad givare
seg_plus = max(0, near(1) - segment)
new_position = track_len(segment + seg_plus);
end


