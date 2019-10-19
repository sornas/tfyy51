%{
GRAPHS: Efter avslutad k�rning skall plottar som sammanfattar k�rningen
visas p� styrdatorns sk�rm. N�dv�ndiga plottar �r:
� En graf som visar varv och varvtider d�r referenstiden och
maximalt till�tna avvikelser �r utm�rkta. Figuren skall ocks� inkludera en 
text som anger standardavvikelsen.
� Gasp�drag mot tid/hastighet f�r varje segment.
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