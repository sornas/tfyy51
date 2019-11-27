function [new_position, seg_plus] = choose_position(position,segment, track, track_len)
%CHOOSE_POSITION Välj vad position ska vara
%   Kör endast vid ny indata. Kollar om indatan är rimlig eller om någon 
%   givare missats. Sedan väljs position efter vilken givare det var som 
%   passerades. seg_plus anger om och med hur mycket car.segment bör
%   justeras för att kompensera efter missad givare.
pos_c = position;

track_len = track_len(1: length(track_len) - 1);

%% Vilken givare ligger närmast pos_c?
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
%% Beräkning av passerad givare
seg_plus = max(0, near(1) - segment)
if segment + seg_plus < 10
    new_position = track_len(segment + seg_plus);
else
    new_position = position;
end


