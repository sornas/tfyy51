function [new_position, seg_plus] = choose_position(position,segment,t_missed, track)
%CHOOSE_POSITION Välj vad position ska vara
%   Kör endast vid ny indata. Kollar om indatan är rimlig eller om någon 
%   givare missats. Sedan väljs position efter vilken givare det var som 
%   passerades. seg_plus anger om och med hur mycket car.segment bör
%   justeras för att kompensera efter missad givare.
track_len = [19.60 2.53 3.05 4.73 7.68 8.98 10.93 14.96 17.57;
             0 0 0 0 0 0 0 0 0];
set_pos = [0 2.53 3.05 4.73 7.68 8.98 10.93 14.96 17.57;
            0 0 0 0 0 0 0 0 0];
pos_c = position;
pos_i = track_len( track, segment);
%% Vilken givare ligger närmast pos_c?
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
%% Beräkning av passerad givare
if near(1) == segment
    new_position = set_pos( track, segment);
    seg_plus = 0;
else
    seg_plus = near(1) - segment
    new_position = set_pos( track, segment)
end
% TODO Bättre att utgå ifrån ingen missad givare ifall ingen annan givare
% är särskillt nära pos_c heller. (Även om det är närmare)
end

