function [out] = detect_missed( position, segment, track)
%DETECT_MISSED Retunerar true om position ligger utanf�r nuvarande segment
%   
a = track_len(segment);
out = a <= position;
end

