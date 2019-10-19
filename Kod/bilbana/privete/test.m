a = [0,1.5,3,2,2,3,4,5,5,4,3,2,1];
time = [0,0.01,0.015,0.02,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12];

%% Test plot 1
figure(1)
subplot(3,1,1)

stairs(time,a,'LineWidth', 2) % Gör en trappstegsplot

xlabel('Time [s]')
ylabel('a')
title('Test plot')

grid on

%% Test plot 2
subplot(3,1,2:3)
stairs(time,a*2,'Marker', '*', 'MarkerFaceColor', 'm')

xlabel('Time [s]')
ylabel('2a')
title('Test plot 2')