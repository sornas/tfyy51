addpath display/ClientServerApp/Release
cd display/ClientServerApp/Release
!startServer
cd ../../..

pause(1);

display = struct;
display.data = [];
display.out = 0;
display.shm = 0;
display.shm_interp = struct;
display.shm_interp.ack = 0;
display.shm_interp.start_code = '';
display.shm_interp.data = [];
display.last_send = tic;
display.send_interval = 0.5;

graphs = struct;
graphs.car1 = struct;
graphs.car2 = struct;
graphs.car1.lap_times = [];  % Nx1
graphs.car1.lap_deviation = std(graphs.car1.lap_times);
graphs.car1.seg_times = [];  % 9xM
graphs.car2.lap_times = [];  % Nx1
graphs.car2.lap_deviation = std(graphs.car2.lap_times);
graphs.car2.seg_times = [];  % 9xM
graphs.laps = max(length(graphs.car1.lap_times), length(graphs.car2.lap_times));

disp('Drawing frame');
% input('');
matlabclient(1, get_smallpackage([ ...
	line(32, 32, 32, 192), ...
	continue_line(298, 192), ...
	line(28, 40, 32, 32), ...
	continue_line(36, 40), ...
	line(298, 188, 298, 196) ...
]));
pause(0.2);

disp('Drawing additional frames');
% input('');
matlabclient(1, get_smallpackage([ ...
	line(190, 0, 190, 70), ...
	continue_line(320, 70) ...
]));
pause(0.2);

disp('Putting text');
% input('');
matlabclient(1, get_smallpackage([
	text(304, 10, 'R', 'std: 0.15s'), ...
	text(304, 30, 'R', 'mean: 12.4s'), ...
	text(304, 50, 'R', 'target: 12.5s') ...
]));
pause(0.2);

disp('Drawing buttons');
% input('');
matlabclient(1, get_smallpackage([ ...
	key(0  , 208, 107, 240, 51, 61, 'C', 'Knapp 1'), ...
	key(107, 208, 213, 240, 52, 62, 'C', 'Knapp 2'), ...
	key(213, 208, 320, 240, 53, 63, 'C', 'Knapp 3') ...
]))
pause(0.2);

disp('');
% input('');
matlabclient(3);
