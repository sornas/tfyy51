function [] = draw_segment_bars(values1, values2)
dt = 0.2;  % delay for display
pause(2*dt);
queue = [];  % internal queue for packages to send to display

matlabclient(1, get_smallpackage(clear_display()));
pause(dt);

matlabclient(1, get_smallpackage(put_text(160, 8, 'C', 'Genomsnittlig tid per segment')))
pause(dt);

% input('');
matlabclient(1, get_smallpackage([ ...
		key(0  , 216, 107, 240, 51, 61, 'C', 'Varv'), ...
		key(107, 216, 213, 240, 52, 62, 'C', 'Segment'), ...
		key(213, 216, 320, 240, 53, 63, 'C', 'Avsluta') ...
]));
pause(dt);

matlabclient(1, get_smallpackage([ ...
		draw_line(20, 24, 20, 200), ...   % y-axis
		put_text(9, 25, 'C', 's'), ...  % label y-axis
		continue_line(304, 200), ... % x-axis
		draw_line(16, 32, 20, 24), ...    % arrow on y, left part
		continue_line(24, 32), ...   % arrow on y, right part
		draw_line(304, 196, 304, 204) ... % line on x
]));
pause(dt);

[bars, max_val, min_y, max_height] = get_bars_from_values(values1, values2);

for bar = bars
	matlabclient(1, get_smallpackage(fill_area(bar.x_lo, bar.y_lo, bar.x_hi, bar.y_hi)));
	pause(dt);
end

for i = 0:8
	x = 16+13 + 10 + 30*i;
	queue = [queue put_text(x, 204, 'C', num2str(i + 1))];
	if i == 4 || i == 8
		matlabclient(1, get_smallpackage(queue));
		queue = [];
		pause(dt);
	end
end

for i = 1:floor(max_val)
	x = 20;
	y = min_y - round(max_height * (i/max_val));
	matlabclient(1, get_smallpackage([... 
			draw_line(x, y, 320, y), ...
			put_text(x-6, y-2, 'C', num2str(i))...
	]));
	pause(dt);
end
end

