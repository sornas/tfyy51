function [] = draw_lap_graph(car1_laptimes, car2_laptimes, ref_time, change_car)
dt = 0.2;  % delay for display

% don't have to re-draw static elements, just the graphs
persistent in_clipboard; 
if is_empty(in_clipboard)
	in_clipboard = false;
end

% draw the other car every time the function is called if the change_car flag is set
% (this value is ignored if only one set of lap times are given)
persistent current_car;
if is_empty(current_car)
	% first call to function
	current_car = 1;
else
	% switch current_car
	if change_car
		if current_car == 1
			current_car = 2;
		else
			current_car = 1;
		end
	end
end

%% STRIP EMPTY VALUES
tmp = [];
for i = 1:length(car1_laptimes)
	if car1_laptimes(i) ~= 0
		tmp = [tmp car1_laptimes(i)];
	end
end
car1_laptimes = tmp;

tmp = [];
for i = 1:length(car2_laptimes)
	if car2_laptimes(i) ~= 0
		tmp = [tmp car2_laptimes(i)];
	end
end
car2_laptimes = tmp;

pause(dt);
matlabclient(1, get_smallpackage(clear_display()));
pause(dt);

%% DRAW STATICS (OR COPY STATICS FROM CLIPBOARD)
if ~(in_clipboard)
	matlabclient(1, get_smallpackage([ ...
			put_text(160, 8, 'C', 'Varvtider'), ...
			key(0  , 216, 107, 240, 51, 61, 'C', 'Varv'), ...
			key(107, 216, 213, 240, 52, 62, 'C', 'Segment'), ...
			key(213, 216, 320, 240, 53, 63, 'C', 'Avsluta'), ...
			key(300, 0  , 320, 24 , 70, 71, 'C', 'Byt bil') ...
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
			put_text(266, y + margin_top, 'C', 'stdev') ...
	]));
	pause(dt);

	car1 = struct;
	car1.avg = '--.-'
	car1.dev = '-.--'
	if ~isempty(car1_laptimes)
		car1.avg = num2str(mean(car1_laptimes), 1);
		car1.dev = num2str(std(car1_laptimes), 2);
	end
	car2 = struct;
	car2.avg = '--.-'
	car2.dev = '-.--'
	if ~isempty(car2_laptimes)
		car2.avg = num2str(mean(car2_laptimes), 1);
		car2.dev = num2str(std(car2_laptimes), 2);
	end

	line = 12;
	matlabclient(1, get_smallpackage([ ...
			put_text(6  , y + 3 + margin_top + line*1, 'L', '1'), ...
			put_text(6  , y + 3 + margin_top + line*2, 'L', '2'), ...
			put_text(53 , y + 2 + margin_top + line*1, 'C', num2str(ref_time)), ...
			put_text(53 , y + 2 + margin_top + line*2, 'C', num2str(ref_time)), ...
			put_text(160, y + 2 + margin_top + line*1, 'C', car1.avg)), ...
			put_text(160, y + 2 + margin_top + line*2, 'C', car2.avg)), ...
			put_text(266, y + 2 + margin_top + line*1, 'C', car1.dev)), ...
			put_text(266, y + 2 + margin_top + line*2, 'C', car2.dev)), ...
	]));
	pause(dt);

	matlabclient(1, get_smallpackage(save_display_to_clipboard()));
	pause(dt);
else
	matlabclient(1, get_smallpackage(restore_display_from_clipboard()));
	pause(dt);
end

%% DRAW GRAPH FOR CAR

laps = -1
% want to keep the same scale in x-axis for both cars so set laps to max of both
laps = max(length(car1_laptimes), length(car2_laptimes))  % TODO check if max([]) == 0
x_min = 20;
dx_max = 260;
% x[lap] = x_min + (dx_max * (i / laps)))

y_min_val = ref_time - 1.5;  % val for lowest y
y_max_val = ref_time + 1.5;  % val for highest y
y_min = 144;
dy_max = -50;
y_mid = y_min + (dy_max)
% y[lap] = clamp(y_min, y_mid + (dy_max * (lap[i] / ref_time)), y_min + 2*dy_max)

times = [];
% choose which lap-times to graph
car = 0;
if current_car == 1 && ~isempty(car1_laptimes)
	times = car1_laptimes;
	car = 1;
elseif current_car == 2 && ~isempty(car2_laptimes)
	times = car2_laptimes;
	car = 2;
% ignore current_car and choose the only carn_laptimes that exist
elseif ~isempty(car1_laptimes)
	times = car1_laptimes;
	car = 1;
elseif ~isempty(car2_laptimes)
	times = car2_laptimes;
	car = 2
else
	% not supposed to get here
end

for i = 1:(length(times))
	x = round(x_min + (dx_max * (i/laps)));
	y = clamp(y_min, ...
			round(y_mid + (dy_max * (times(i) / ref_time))), ...
			y_min + 2*dy_max ...
	);
	matlabclient(1, get_smallpackage([ ...
			set_point_size(3, 3), ...
			point(x, y), ...
			set_point_size(1, 1), ...
			draw_line(x, 144-2,  x, 144+2) ...
	]));
	pause(dt);
end
max_lap_nums = 9;
d_lap = floor(laps/max_lap_nums) + 1;
% examples: 
% laps = 8
	% d_lap = floor(8/9) + 1 = 0 + 1 = 1
% laps = 10
	% d_lap = floor(10/9) + 1 = 1 + 1 = 2
for i = 1:(length(times))
	if mod(i, d_lap) == 0
		x = round(x_min + (dx_max * (i/laps)));
		y = y_min + 4;
		matlabclient(1, get_smallpackage([ ...
				put_text(x, y, 'C', num2str(i)) ...
		]));
	end
end
end
