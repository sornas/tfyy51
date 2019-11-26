function [car, stop, display_data] = do_car(car, t, display_data, boot)
%DO_CAR Ger nya v�rden till struct car, avg�r om koden ska stoppas samt h�mtar displaydata.
%{
Input/Output:
car - En struct med data f�r en viss bil    
    car.num - Vilken bil det �r (1 eller 2)
    car.running - Om bilen k�rs eller inte
    car.automatic - Om bilen k�rs automatiskt eller inte
    car.segment - Bilens nuvarande segment
    car.lap - Bilens nuvarande varv
    car.lap_times - Bilens sparade varvtider (1 x v matris)
    car.seg_times - Bilens sparade segmentstier (v x 9 matris)
    car.seg_constant_list = []; % TODO Sparar alla seg_constants som
        anv�nts (v x 9 matris)
    car.position - Bilens nuvarande placering p� banan i meter fr�n
        start/m�l
    car.seg_len - Banans l�ngd fr�n start till givarna (1 x 9 matris)
    car.map - Tabell med hastighetskoefficienter f�r alla positioner (.mat
    fil)
    car.miss_probability - Sannorlikheten f�r artificiellt introducerade
        missade givare
    car.lap_constants = [1,1,1,1,1,1,1,1,1]; % TODO seg_constanst f�r
    nuvarande varv. Skapas av gov_set() vid nytt varv
t - L�ngden (s) p� nuvarande programcykel
display_data - Buffer med den data som ska skickas till displayen vid n�sta
anrop
stop - Huruvida koden ska stoppas eller inte
%}

stop = false;
if car.running == true
	[car.new_lap, car.new_check_point, car.time] = get_car_position(car.num);
	if car.new_check_point == true && rand < car.miss_probability && car.lap >= 4
		disp('Hoppar �ver givare');
		car.new_check_point = false;
		beep;
	end
end

if car.stopped == true
	return
end

%% READ INPUT FROM TRACK
if car.running == true
	if car.lap ~= 0
		if toc(car.seg_tic) > 9.0 && not(boot.status)
			set_car_speed(1, 0);
			set_car_speed(2, 0);
			%disp(strjoin({'Avåkning bil', num2str(car.num)}));
			disp('J = Ja, N = Nej')
			car.response = input('Vill du fortsätta? [N] ', 's');
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
		aprox_v = get_aprox_v(car.segment + detect_missed(car.position, car.segment, car.num, car.pos_at), car.lap, car.seg_times, car.num, car.seg_len);
		car.position = get_position(aprox_v, car.position, t);
		if detect_missed( car.position, car.segment, car.num, car.pos_at)
			disp('Miss?');

			%disp(toc(car.miss_time));
			%if car.miss_time == 0
			%   car.miss_time = tic;
			%end
		end
	end

	if car.stopping == true
		% CHECK IF CAR IS AT THE END OF TRACK
		if car.position > (car.map(80, 1) / 100) - 0.8  % 80cm
			disp(car.position)
			disp((car.map(80, 1) / 100) - 300)
			set_car_speed(car.num, 0);
			car.stopped = true;
			return
		end
	end

	%% CHECK POINT
	if car.new_check_point == true
		if car.new_lap == false % choose_position krachar vid nytt varv (seg 10)
			if car.lap ~= 0
				car.seg_times(car.lap, car.segment) = toc(car.seg_tic);
            end
            
            seg_time = car.seg_times(car.lap, car.segment);
            car.forecasts(car.lap, car.segment) = seg_time / car.percents(car.segment);
            
			car.segment = car.segment + 1;
			car.seg_tic = tic;
			if car.lap > 2 % S�kerhetsmarginal (B�r vara 1?)
				disp(car)
				[new_position, seg_plus] = ...
						choose_position(car.position, car.segment, car.num, car.pos_at);
                if seg_plus ~= 0 && car.segment == 2
					disp('Hoppar �ver missad givare 1/2');
				else
					car.position = new_position;
					car.segment = car.segment + seg_plus;
                end
                if seg_plus ~= 0 && car.segment ~= 2
                    car.seg_times(car.lap, car.segment - seg_plus - 1) = 0;
                    disp(car.seg_times(car.lap, :))
                    disp(seg_plus)
                end
				%car.miss_time = uint64(0);
			else
				car.position = car.pos_at(car.segment);
				%car.miss_time = uint64(0);
			end
		end
	end

	%% NEW LAP
	if car.new_lap == true
        disp('NEW LAP')
        
        car.lap_constants = gov_set(car.constant);
		car.new_lap = false; %TODO remove
		beep;
		if car.lap == 0
			% dont save time for first lap
			car.segment = 1;
			car.lap = car.lap + 1;
			car.seg_tic = tic;
			car.lap_tic = tic;
		else
			% beep;
			% Spara inte seg_time om missad givare
			if car.segment == 9
				car.seg_times(car.lap, car.segment) = toc(car.seg_tic);
			end
			car.seg_tic = tic;
			car.lap_times(car.lap) = toc(car.lap_tic);
			car.lap_tic = tic;
			car.position = 0;

            % save segment percentage from last lap
            car.percents = fit_percents(car.percents, car.lap_times(car.lap), car.seg_times(car.lap,:))
            
			if car.lap == 1 && size(car.seg_times, 2) < 9
				disp('FEL: F�r f� segment!!')
				car.stopped = true;
				other_car.stopped = true;
				return
			end

			display_data = [display_data, put_text(100, 16 + (16 * car.num), 'L', strjoin({num2str(car.lap), get_time_as_string(round(car.lap_times(car.lap) * 1000))}, ' '))];

			car.segment = 1;
			car.lap = car.lap + 1;
		end
	end
end

%% CALCULATE
if car.running == true && car.automatic == true
	car.v = get_new_v(car.position, car.map);
	car.u = get_new_u(car.v, car.constant);
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
