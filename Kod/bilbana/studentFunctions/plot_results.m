% Plot the results
figure(100)
subplot(2,1,1)
stairs(car.control_log_time, car.control, 'LineWidth', 2) % Gör en trappstegsplot
xlabel('Time [s]')
ylabel('Control signal [%]')
title('Control signal trajectory')
grid on

subplot(2,1,2)
stairs(car.control_log_time, car.control_log_position, 'r', 'LineWidth', 2)
xlabel('Time [s]')
ylabel('Car position [segment number]')
title('Car position')
grid on
