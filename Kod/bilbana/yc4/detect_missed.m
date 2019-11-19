function [out] = detect_missed( position, segment, track, track_len)
%DETECT_MISSED Retunerar true om position ligger utanför nuvarande segment
%   

track_len = track_len(2: length(track_len));
a = track_len(segment);
out = a <= position;
end

