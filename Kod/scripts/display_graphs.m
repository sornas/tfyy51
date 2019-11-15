addpath display/ClientServerApp/Release
cd display/ClientServerApp/Release
!startServer
cd ../../..

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
graphs.car1.lap_deviation = std(graphs.car1.lap_times)
graphs.car1.seg_times = [];  % 9xM
graphs.car2.lap_times = [];  % Nx1
graphs.car2.lap_deviation = std(graphs.car2.lap_times)
graphs.car2.seg_times = [];  % 9xM
graphs.laps = max(length(graphs.car1.lap_times), length(graphs.car2.lap_times))

disp('Drawing frame');
input();
matlabclient(1, get_smallpackage([ ...
	draw_single_line(32, 32, 32, 192), ...
	continue_line(298, 192), ...
	draw_single_line(28, 40, 32, 32), ...
	continue_line(36, 40), ...
	draw_single_line(298, 188, 298, 196) ...
]));
pause(0.2);

disp('Drawing additional frames');
input();
matlabclient(1, get_smallpackage([ ...
	draw_single_line(220, 0, 220, 80), ...
	continue_line(0, 80), ...
	draw_single_line(0, 208, 320, 208) ...
]));
pause(0.2);

disp('Putting text');
input();
matlabclient(1, get_smallpackage([
	put_text(304, 20, 'R', 'std: 0.15s'), ...
	put_text(304, 40, 'R', 'mean: 12.4s'), ...
	put_text(304, 60, 'R', 'target: 12.5s') ...
]));
pause(0.2);

disp('Drawing buttons');
input();
matlabclient(1, get_smallpackage([ ...
	define_touch_key(0  , 208, 107, 240, 51, 61, 'C', 'Knapp 1'), ...
	define_touch_key(107, 208, 213, 240, 52, 62, 'C', 'Knapp 2'), ...
	define_touch_key(213, 208, 320, 240, 53, 63, 'C', 'Knapp 3') ...
]))
pause(0.2);

disp('');
input();
matlabclient(1, get_smallpackage([]))
pause(0.2);
