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
ref_lap_time = 14;
track = 1;
%% Figur
figure(1);
clf;
subplot(10,1,1:9);
%% Raka streck
ref_lap_time_vector = ref_lap_time*ones(1,length(car1.lap_times));

Min_c = ref_lap_time-0.5;
Max_c = ref_lap_time+0.5;
InD_c = ref_lap_time-1;
InU_c = ref_lap_time+1;

Min = Min_c*ones(1,length(car1.lap_times));
Max = Max_c*ones(1,length(car1.lap_times));
InU = InU_c*ones(1,length(car1.lap_times));
InD = InD_c*ones(1,length(car1.lap_times));
%% Varvtider
disp(car1.lap_times);
disp(ref_lap_time_vector);
plot1 = stairs(car1.lap_times);
plot1.Marker = 'o';
plot1.MarkerFaceColor = 'k';
plot1.LineStyle = 'none';
hold on
%% Referenstid
plot2 = stairs(ref_lap_time_vector);
plot2.LineWidth = 2;
plot2.Color = 'k';
%% Tillåten avvikelse
plotMax = stairs(Max);
plotMin = stairs(Min);
plotMax.Color = 'k';
plotMin.Color = 'k';
%% Osynliga hjälpstreck
plotInU = stairs(InU);
plotInD = stairs(InD);
plotInU.LineStyle = 'none';
plotInD.LineStyle = 'none';

hold off
%% Standardavvkielse
sigma = std(car1.lap_times);
sigma = round(sigma, 2);
sig_str = string(sigma);
%% Text
xlabel('Varv');
ylabel('Tid [s]');
title('Varvtider'); %Todo vilken bana?
txt = join(['Standardavvikelse:',sig_str, 's']);
annotation('textbox',[.1 0.05 .4 .05],'String',txt,'EdgeColor','none')
disp(sig_str);