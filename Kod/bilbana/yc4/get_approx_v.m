function [v] = get_approx_v(cur_seg, car)
%GET_APROX_V Retunerar medelhastiheten f�r nuvarande segment fr�n tidigare
%varv
%{
In:
    cur_seg: Nuvarande segment
    car: en struct - se do_car.m
Ut:
    v: Uppskattning av nuvarande hastiheten [m/s]
%}
lap = car.lap;
if cur_seg > 9
    cur_seg = cur_seg - 9;
end
%% Kompensera f�r v�ldigt l�ngsamt segment 1 f�rsta varvet
if cur_seg == 1 && lap == 2
    v = car.seg_len(1)/(1.4*car.seg_times(1,9));
    return
end
%% S�tt v
while lap > 0
    lap = lap - 1;
    if car.seg_times(lap, cur_seg) ~= 0
        v = car.seg_len(cur_seg) / car.seg_times(lap, cur_seg);
        return
    end
end
end
