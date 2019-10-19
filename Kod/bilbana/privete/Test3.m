%{
GRAPHS: Efter avslutad körning skall plottar som sammanfattar körningen
visas på styrdatorns skärm. Nödvändiga plottar är:
• En graf som visar varv och varvtider där referenstiden och
maximalt tillåtna avvikelser är utmärkta. Figuren skall också inkludera en 
text som anger standardavvikelsen.
• Gaspådrag mot tid/hastighet för varje segment.
%}
disp('Startar test av grafer')
%% IN
ref_lap_time = 13;
%% Bana 1
figure(1);
%% Varvtid
ref_lap_time_vector = ref_lap_time*ones(1,length(car1.lap_times));

subplot(1,1,1);
disp(car1.lap_times);
disp(ref_lap_time_vector);
plot1 = stairs(car1.lap_times);
plot1(1).Marker = 'o';
plot1(1).MarkerFaceColor = 'k';
plot1(1).LineStyle = 'none';
hold on
plot2 = stairs(ref_lap_time_vector);
plot2(1).LineWidth = 2;
plot2(1).Color = 'k';
hold off



xlabel('Varv');
ylabel('Tid [s]');
title('Varvtider');