%{
GRAPHS: Efter avslutad k�rning skall plottar som sammanfattar k�rningen
visas p� styrdatorns sk�rm. N�dv�ndiga plottar �r:
� En graf som visar varv och varvtider d�r referenstiden och
maximalt till�tna avvikelser �r utm�rkta. Figuren skall ocks� inkludera en 
text som anger standardavvikelsen.
� Gasp�drag mot tid/hastighet f�r varje segment.
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