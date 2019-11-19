function [v] = get_aprox_v(cur_seg, lap, seg_times, track, seg_len)
%GET_APROX_V Tillf�llig? Beh�vs f�r att testa get_position. Ger
%medelhastigheten f�r nuvarande segment p� f�rra varvet.
%{
cur_seg: Nuvarande segment
last_seg_times: 1x9 vektor med f�rra varvets segmenttider
%}
% seg_len = [];

if cur_seg > 9
    cur_seg = cur_seg - 9;
end

while lap > 0
    lap = lap - 1;
    if seg_times(lap, cur_seg) ~= 0
        v = seg_len(cur_seg) / seg_times(lap, cur_seg);
        return
    end
end
disp('bara nollor?');

end
