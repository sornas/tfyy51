function [] = segment_time_graph(seg_time,track)
%SEGMENT_TIME_GRAPH Snittid för varje segment.

avr_seg_time = mean(seg_time);
subplot(20,1,13:20);

Plot = bar(avr_seg_time);
%Plot.Marker = 'o';
Plot.FaceColor = 'k';
xlabel('Segment');
ylabel('Tid [s]');
Tit = join(['Medeltid/segment bana',string(track)]);
title(Tit); 
end

