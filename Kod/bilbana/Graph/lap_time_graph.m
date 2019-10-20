function [outputArg1,outputArg2] = lap_time_graph(lap_times, track, ref_lap_time)
%LAP_TIME_GRAPH En graf som visar varvtider där referenstiden och maximalt 
%tillåtna avvikelser är utmärkta. Figuren inkluderar också standardavvikelsen
%%
subplot(20,1,1:8);
%% Raka streck
ref_lap_time_vector = ref_lap_time*ones(1,length(lap_times));

Min_c = ref_lap_time-0.5;
Max_c = ref_lap_time+0.5;
InD_c = ref_lap_time-1;
InU_c = ref_lap_time+1;

Min = Min_c*ones(1,length(lap_times));
Max = Max_c*ones(1,length(lap_times));
InU = InU_c*ones(1,length(lap_times));
InD = InD_c*ones(1,length(lap_times));
%% Varvtider
plot1 = stairs(lap_times);
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
sigma = std(lap_times);
sigma = round(sigma, 2);
sig_str = string(sigma);
%% Text
xlabel('Varv');
ylabel('Tid [s]');
Tit = join(['Varvtider bana',string(track)]);
title(Tit); 
txt = join(['Standardavvikelse:',sig_str, 's/varv']);
annotation('textbox',[.1 0.5 .5 .05],'String',txt,'EdgeColor','none')
end

