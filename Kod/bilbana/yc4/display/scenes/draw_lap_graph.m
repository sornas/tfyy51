function [] = draw_lap_graph(car1_laptimes, car2_laptimes, ref_time)
if isempty(car1_laptimes)
    car1_laptimes = car2_laptimes;
    car2_laptimes = [];
end

laps = max(length(graphs.car1.lap_times), length(graphs.car2.lap_times));

pause(0.2);
matlabclient(1, get_smallpackage(clear_display()));
pause(0.2);

matlabclient(1, get_smallpackage(put_text(105, 8, 'C', 'Varvtider')))
pause(0.2);

matlabclient(1, get_smallpackage([ ...
	key(0  , 216, 107, 240, 51, 61, 'C', 'Varv'), ...
	key(107, 216, 213, 240, 52, 62, 'C', 'Segment'), ...
	key(213, 216, 320, 240, 53, 63, 'C', 'Avsluta') ...
]));
pause(0.2);

matlabclient(1, get_smallpackage([ ...
	draw_line(20, 24, 20, 200), ...   % y-axis
	continue_line(304, 200), ... % x-axis
	draw_line(16, 32, 20, 24), ...    % arrow on y, left part
	continue_line(24, 32), ...   % arrow on y, right part
	draw_line(304, 196, 304, 204) ... % line on x
]));
pause(0.2);

matlabclient(1, get_smallpackage([ ...
	draw_line(190, 0, 190, 70), ...
	continue_line(320, 70) ...
]));
pause(0.2);

matlabclient(1, get_smallpackage(save_display_to_clipboard()));

%%
matlabclient(1, get_smallpackage(draw_line(20, 103, 320, 103)));
matlabclient(1, get_smallpackage(draw_line(20, 135, 320, 135)));
matlabclient(1, get_smallpackage(draw_line(20, 167, 320, 167)));

matlabclient(1, )

%%
matlabclient(1, get_smallpackage([
	put_text(304, 10, 'R', 'std: x.xxs'), ...
	put_text(304, 30, 'R', 'mean: xx.xs'), ...
	put_text(304, 50, 'R', 'target: xx.xs') ...
]));
pause(0.2);
end
