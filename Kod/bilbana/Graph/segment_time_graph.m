function [] = segment_time_graph(seg_times, track)
%SEGMENT_TIME_GRAPH Stapeldiagram med snittid för varje segment.
    %{
    Utgår ifrån en r*k matris (seg_times). I den finns segmenttider lagrade
    enligt rad ~ varv och kollonn ~ segment. Funktionen summerar alla 
    kollonner och delar summan med antalet kolloner som inte har värdet 0.

    Sedan ritas ett stapeldiagram där varje stapel motsvarar en kollon i
    den nyligen beräknade 1*k matrisen.  
    %}
seg_time_size = size(seg_times);
divide_by_n = ones(1,seg_time_size(2));
%% Summera seg_time om seg_time ~= 0
for r = 1:seg_time_size(1)
    if r == 1
        avr_seg_time(1:seg_time_size(2)) = seg_times(1:seg_time_size(2));
    else
        for c = 1:seg_time_size(2) 
            x = seg_times(r,c);
            if x ~= 0
                avr_seg_time(c) = avr_seg_time(c) + seg_times(r,c);
                divide_by_n(c) = divide_by_n(c) + 1;
            end
        end
    end  
end
%% Ta medel av summan
for c =1:seg_time_size(2)
        avr_seg_time(c) = avr_seg_time(c)/divide_by_n(c);
end
%% Rita
subplot(20, 1, 13:20);
Plot = bar(avr_seg_time);
Plot.FaceColor = 'k';
xlabel('Segment');
ylabel('Tid [s]');
tit = char(['Medeltid/segment bana',char(track)]);
title(tit); 
end

