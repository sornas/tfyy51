function [] = draw_lap_graph(car1_laptimes, car2_laptimes, ref_time)
dt = 0.2;  % delay for display

if isempty(car1_laptimes)
	car1_laptimes = car2_laptimes;
	car2_laptimes = [];
end

% laps = max(length(graphs.car1.lap_times), length(graphs.car2.lap_times));

pause(dt);
matlabclient(1, get_smallpackage(clear_display()));
pause(dt);

matlabclient(1, get_smallpackage(put_text(160, 8, 'C', 'Varvtider')))
pause(dt);

matlabclient(1, get_smallpackage([ ...
		key(0  , 216, 107, 240, 51, 61, 'C', 'Varv'), ...
		key(107, 216, 213, 240, 52, 62, 'C', 'Segment'), ...
		key(213, 216, 320, 240, 53, 63, 'C', 'Avsluta') ...
]));
pause(dt);

matlabclient(1, get_smallpackage([ ...
		draw_line(20, 24, 20, 144), ...   % y-axis
		put_text(9, 25, 'C', 's'), ...  % label y-axis
		continue_line(304, 144), ... % x-axis
		draw_line(16, 32, 20, 24), ...    % arrow on y, left part
		continue_line(24, 32), ...   % arrow on y, right part
		draw_line(304, 140, 304, 148) ... % line on x
]));
pause(dt);

y = 166;
margin_top = 6;
matlabclient(1, get_smallpackage([ ...
		draw_line(0, y, 320, y), ...
		put_text(53 , y + margin_top, 'C', 'target'), ...
		put_text(160, y + margin_top, 'C', 'mean'), ...
		put_text(266, y + margin_top, 'C', 'std') ...
]));
pause(dt);

line = 12;
matlabclient(1, get_smallpackage([ ...
		put_text(6  , y + 3 + margin_top + line*1, 'L', '1'), ...
		put_text(6  , y + 3 + margin_top + line*2, 'L', '2'), ...
		put_text(53 , y + 2 + margin_top + line*1, 'C', 'xx.x'), ...
		put_text(53 , y + 2 + margin_top + line*2, 'C', 'xx.x'), ...
		put_text(160, y + 2 + margin_top + line*1, 'C', 'xx.x'), ...
		put_text(160, y + 2 + margin_top + line*2, 'C', 'xx.x'), ...
		put_text(266, y + 2 + margin_top + line*1, 'C', 'x.xx'), ...
		put_text(266, y + 2 + margin_top + line*2, 'C', 'x.xx'), ...
]));
pause(dt);

times = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];
for i = 0:(length(times)-1)
x = 28 + i*10;
y = 144 - round(100 * (times(i+1) / max(times)));
matlabclient(1, get_smallpackage([ ...
			set_point_size(3, 3), ...
			point(x, y), ...
			set_point_size(1, 1), ...
			draw_line(x, 144-2,  x, 144+2) ...
]));
pause(0.15);
end

% matlabclient(1, get_smallpackage(save_display_to_clipboard()));
end
