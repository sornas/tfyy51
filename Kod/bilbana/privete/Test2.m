%{
GRAPHS: Efter avslutad körning skall plottar som sammanfattar körningen
visas på styrdatorns skärm. Nödvändiga plottar är:
• En graf som visar varv och varvtider där referenstiden och
maximalt tillåtna avvikelser är utmärkta. Figuren skall också inkludera en 
text som anger standardavvikelsen.
• Gaspådrag mot tid/hastighet för varje segment.
%}
disp('Startar test av grafer')
%% Bana 1
figure(2);
%% Varvtid
subplot(1,1,1);
plot1 = stairs(car1.lap_times);

plot1(1).Marker = 'o';
plot1(1).MarkerFaceColor = 'k';
plot1(1).LineStyle = 'none';
xlabel('Varv');
ylabel('Tid [s]');
title('Varvtider');