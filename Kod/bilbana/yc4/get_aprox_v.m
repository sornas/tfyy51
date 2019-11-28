function [v] = get_aprox_v(cur_seg, car)
%GET_APROX_V Tillfï¿½llig? Behï¿½vs fï¿½r att testa get_position. Ger
%medelhastigheten fï¿½r nuvarande segment pï¿½ fï¿½rra varvet.
%{
cur_seg: Nuvarande segment
last_seg_times: 1x9 vektor med fï¿½rra varvets segmenttider
%}
% seg_len = [];
lap = car.lap;
if cur_seg > 9
    cur_seg = cur_seg - 9;
end
%% Kompensera för väldigt långsamt segment 1 första varvet
if cur_seg == 1 && lap == 2
    v = car.seg_len(1)/(1.5*car.seg_times(1,9))
    return
end
%% Sätt v
while lap > 0
    lap = lap - 1;
    if car.seg_times(lap, cur_seg) ~= 0
        v = car.seg_len(cur_seg) / car.seg_times(lap, cur_seg);
        return
    end
end
end
