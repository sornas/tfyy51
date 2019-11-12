function [out] = detect_missed( position, segment, track)
%DETECT_MISSED Retunerar true om position ligger utanför nuvarande segment
%   
track_len = [2.53 3.05 4.73 7.68 8.98 10.93 14.96 17.57 19.60;
             2.53 3.05 4.92 7.60 8.84 10.65 14.68 17.76 19.95];
a = track_len(track, segment);
out = a <= position;
end

