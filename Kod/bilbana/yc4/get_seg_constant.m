function [out] = get_seg_constant(position, track)
%GET_SEG_CONSTANT Summary of this function goes here
%   Detailed explanation goes here
track_len = [0 2.53 3.05 4.73 7.68 8.98 10.93 14.96 17.57;
             0 2.53 3.05 4.92 7.60 8.84 10.65 14.68 17.76];
for i = 1:length(track_len)
    if position > track_len(track, i)
        seg_constant = track_len(track, i);
    end
end
out = seg_constant;
end

