function [car, stop, display_data] = do_car(car, t, display_data)
%DO_CAR Ger nya värden till struct car, avgör om koden ska stoppas samt hämtar displaydata.
%{
Input/Output:
car - En struct med data för en viss bil    
    car.num - Vilken bil det är (1 eller 2)
    car.running - Om bilen körs eller inte
    car.automatic - Om bilen körs automatiskt eller inte
    car.segment - Bilens nuvarande segment
    car.lap - Bilens nuvarande varv
    car.lap_times - Bilens sparade varvtider (1 x n matris)
    car.seg_times - Bilens sparade segmentstier (n x m matris)
    car.position - Bilens nuvarande placering på banan i meter från
        start/mål
    car.seg_len - Banans längd från start till givarna (1 x 9 matris)
    car.map - Tabell med hastighetskoefficienter för alla positioner (.mat
    fil)
    car.miss_probability - Sannorlikheten för artificiellt introducerade
        missade givare
t - Längden (s) på nuvarande programcykel
display_data - Buffer med den data som ska skickas till displayen vid nästa
    anrop
stop - Huruvida koden ska stoppas eller inte
%}
stop = false;
if car.running == true
	[car.new_lap, car.new_check_point, car.time] = get_car_position(car.num);
	if car.new_check_point == true && rand < car.miss_probability && car.lap >= 4
		disp('Hoppar ï¿½ver givare');
		car.new_check_point = false;
		beep;
	end
end

%% CHECK LAP AND CHECKPOINT
if car.running == true
	if car.lap ~= 0
		if toc(car.seg_tic) > 9.0
			set_car_speed(1, 0);
			set_car_speed(2, 0);
			%disp(strjoin({'AvÃ¥kning bil', num2str(car.num)}));
			disp('J = Ja, N = Nej')
			car.response = input('Vill du fortsÃ¤tta? [N] ', 's');
			if car.response == 'J'
				car.seg_tic = tic;
			else
				stop = true;
				return;
			end
		end
	end
	%% CALC POSITION
	if car.lap > 1
		% car.last_seg_times = car.seg_times(car.lap - 1, 1:9);
		aprox_v = get_aprox_v(car.segment + detect_missed(car.position, car.segment, car.num), car.lap, car.seg_times, car.num);
		car.position = get_position(aprox_v, car.position, t);
		if detect_missed( car.position, car.segment, car.num)
			disp('Miss?');
			
			%disp(toc(car.miss_time));
			%if car.miss_time == 0
			 %   car.miss_time = tic;
			%end
		end
	end
	if car.new_check_point == true
		if car.new_lap == false % choose_position krachar vid nytt varv (seg 10)
			if car.lap ~= 0
				car.seg_times(car.lap, car.segment) = toc(car.seg_tic);
			end
			car.segment = car.segment + 1;
			car.seg_tic = tic;
			if car.lap > 2 % Sï¿½kerhetsmarginal (Bï¿½r vara 1?)
				disp(car);
				[new_position, seg_plus] = ...
						choose_position(car.position, car.segment, car.num);
				if seg_plus ~= 0 && car.segment == 1
					disp('Hoppar ï¿½ver missad givare 1/2');
				else
					car.position = new_position;
					car.segment = car.segment + seg_plus;
				end
				%car.miss_time = uint64(0);
			else
				car.position = car.seg_len(car.segment);
				%car.miss_time = uint64(0);
			end
		end
	end
	if car.new_lap == true
		car.new_lap = false;
		beep;
		if car.lap == 0
			% dont save time for first lap
			car.segment = 1;
			car.lap = car.lap + 1;
			car.seg_tic = tic;
			car.lap_tic = tic;
		else
		% beep;
			car.seg_times(car.lap, car.segment) = toc(car.seg_tic);
			car.seg_tic = tic;
			car.lap_times(car.lap) = toc(car.lap_tic);
			car.lap_tic = tic;
			car.position = 0;

			display_data = [display_data, put_text(100, 16 + (16 * car.num), 'L', strjoin({num2str(car.lap), get_time_as_string(round(car.lap_times(car.lap) * 1000))}, ' '))];

			car.segment = 1;
			car.lap = car.lap + 1;
		end
	end
end

%% CALCULATE
if car.running == true && car.automatic == true
	car.car_constant = get_car_constant(car.num);
	car.v = get_new_v(car.position, car.map);
	car.track_u_constant = get_track_u_constant();
	car.u = get_new_u(car.v, car.car_constant, car.track_u_constant);
end

%% CONTROLLER
if car.running == true && car.automatic == false
	% set_car_speed(car.num, mult * ((max - get_manual_speed(car.num)) / div));
end

%% EXECUTE
if car.running == true && car.automatic == true
	set_car_speed(car.num, car.u);
end
end
