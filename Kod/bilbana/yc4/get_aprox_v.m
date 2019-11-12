function [v] = get_aprox_v(cur_seg, lap, seg_times, track)
%GET_APROX_V Tillf�llig? Beh�vs f�r att testa get_position. Ger
%medelhastigheten f�r nuvarande segment p� f�rra varvet.
%{
cur_seg: Nuvarande segment
last_seg_times: 1x9 vektor med f�rra varvets segmenttider
%}
seg_len1 = [2.53 0.53 1.68 2.92 1.2 2.01 3.83 2.89 1.99];
seg_len2 = [2.53 0.53 1.87 2.68 1.24 1.81 4.03 3.09 2.19];

seg_len = (track == 1 : seg_len1 : seg_len2);

if cur_seg > 9
    cur_seg = cur_seg - 9;
end

while lap > 0
    lap = lap - 1;
    if seg_times(lap, cur_seg) ~= 0
        v = seg_len(cur_seg)/seg_times(lap, cur_seg);
        return
    end
end
disp('bara nollor?');

end
