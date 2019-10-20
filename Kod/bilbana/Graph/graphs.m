function [] = graphs(lap_times, ref_lap_time, seg_times, track)
%{GRAPHS: Tv� grafer i samma figur. Varvtider och medeltid/segment
%{   
lap_times: vektor med alla varvtider, 
ref_lap_time: Den varvtid som efterstr�vas
seg_times: matris med segmentstider fr�n alla varv
track: den bana som de andra argumenten g�ller f�r
%}
figure(track);
clf;
lap_time_graph(lap_times, track, ref_lap_time);
segment_time_graph(seg_times, track);
end

