function [new_position, seg_plus] = choose_position(position,segment, track)
%CHOOSE_POSITION Välj vad position ska vara
%   Kör endast vid ny indata. Kollar om indatan är rimlig eller om någon 
%   givare missats. Sedan väljs position efter vilken givare det var som 
%   passerades. seg_plus anger om och med hur mycket car.segment bör
%   justeras för att kompensera efter missad givare.
track_len = [0 2.53 3.05 4.73 7.68 8.98 10.93 14.96 17.57;
             0 2.53 3.05 4.92 7.60 8.84 10.65 14.68 17.76];
pos_c = position;
%% Vilken givare ligger närmast pos_c?
near = [];
for i = 1:length(track_len)
    diff = abs(track_len(track, i) - pos_c);
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
new_position = track_len(track, segment + seg_plus);
end


