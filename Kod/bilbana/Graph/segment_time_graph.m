function [] = segment_time_graph(seg_time, track)
%SEGMENT_TIME_GRAPH Snittid för varje segment.
seg_time_size = size(seg_time);
avr_seg_time = mean(seg_time(1:(seg_time_size(1) - 1), 1:(seg_time_size(2))));
subplot(20, 1, 13:20);

Plot = bar(avr_seg_time);
%Plot.Marker = 'o';
Plot.FaceColor = 'k';
xlabel('Segment');
ylabel('Tid [s]');
tit = join(['Medeltid/segment bana',string(track)]);
title(tit); 
end

