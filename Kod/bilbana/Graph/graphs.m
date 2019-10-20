function [] = graphs(lap_times, ref_lap_time, seg_times, track)
%{GRAPHS: Två grafer i samma figur. Varvtider och medeltid/segment
%{   
lap_times: vektor med alla varvtider, 
ref_lap_time: Den varvtid som eftersträvas
seg_times: matris med segmentstider från alla varv
track: den bana som de andra argumenten gäller för
%}
figure(track);
clf;
lap_time_graph(lap_times, track, ref_lap_time);
segment_time_graph(seg_times, track);
end

