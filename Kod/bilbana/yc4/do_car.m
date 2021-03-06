function [car, halt, display_data] = do_car(car, t, display_data, boot)
%DO_CAR Ger nya v�rden till struct car, avg�r om koden ska stoppas samt h�mtar displaydata.
%{
Input/Output:
car - En struct med data f�r en viss bil    
    car.num - Vilken bil det �r (1 eller 2)
    car.running - Om bilen k�rs eller inte
    car.stopping - Logiskt v�rde som indikerar om bilen snart ska
        stannas
    car.stopped - Bilen har stannat och ska inte flyttas p�
    car.automatic - Om bilen k�rs automatiskt eller inte
    car.segment - Bilens nuvarande segment
    car.lap - Bilens nuvarande varv
    car.lap_times - Bilens sparade varvtider (1 x v matris)
    car.seg_times - Bilens sparade segmentstier (v x 9 matris)
    car.seg_constant_list = []; % TODO Sparar alla seg_constants som
        anv�nts (v x 9 matris)
    car.position - Bilens nuvarande placering p� banan i meter fr�n
        start/m�l
    car.pos_at  - Str�ckan till m�lgivaren [m] fr�n varje givare 
        (1 x 10 matris)
    car.seg_len = L�ngden p� varje segment [m] (1 x 9 matris)    
    car.percents - Upskattad andel av varvtiden som varje segment b�r ta
        (1 x 9 matris)
    car.map - Tabell med hastighetskoefficienter f�r alla positioner 
        (.mat fil)
    car.miss_probability - Sannorlikheten f�r artificiellt introducerade
        missade givare
    car.constant - Parameter som anv�nds f�r att s�tta sp�nningen till banan
t - L�ngden (s) p� nuvarande programcykel
display_data - Buffer med den data som ska skickas till displayen vid n�sta
    anrop
boot - En struct med info relaterad till bootstrap
    boot.status - Logiskt v�rde som indikerar ifall bootstap k�rs eller ej
    boot.time - Tiden sedan bootstrap h�jde car.constant
halt - Huruvida koden ska stoppas eller inte


%}

halt = false;
if car.running == true
	[car.new_lap, car.new_check_point, car.time] = get_car_position(car.num);
	if car.new_check_point == true && rand < car.miss_probability && car.lap > 5
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
	if car.lap ~= 0 && not(boot.status)
        if toc(car.seg_tic) > 9.0
			set_car_speed(1, 0);
			set_car_speed(2, 0);
			disp(strjoin({'Av�kning bil', num2str(car.num)}));
			disp('(J = Ja, N = Nej)');
			car.response = input('Vill du forts�tta? [N] ', 's');
            if car.response == 'J'
				car.seg_tic = tic;
			else
				halt = true;
				return;
            end
        end
	end

	%% CALC POSITION
    if car.automatic && car.lap > 1
		% car.last_seg_times = car.seg_times(car.lap - 1, 1:9);
		aprox_v = get_aprox_v(car.segment + detect_missed(car.position, car.segment, car.num, car.pos_at), car);
		car.position = get_position(aprox_v, car.position, t);
        if car.lap == 2 && car.segment < 4
            % disp('####')
            % disp(car.position)
        end
        if detect_missed( car.position, car.segment, car.num, car.pos_at)
			% disp('Miss?');

			%disp(toc(car.miss_time));
			%if car.miss_time == 0
			%   car.miss_time = tic;
			%end
        end
    end

	if car.automatic && car.stopping == true
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

			lap_time_now = toc(car.lap_tic);
			% s = vt
			% v = s/t
			% t = s/v
			prev_seg_v = car.seg_len(car.segment) / toc(car.seg_tic);
			track_remaining = car.pos_at(length(car.pos_at)) - car.pos_at(car.segment + 1);
			car.forecasts(car.lap, car.segment) = lap_time_now + track_remaining/prev_seg_v;

			car.forecasts_naive(car.lap, car.segment) = toc(car.seg_tic) / car.percents(car.segment);

			car.segment = min(9, car.segment + 1);
			car.seg_tic = tic;

			if car.automatic && car.lap > 2 % S�kerhetsmarginal (B�r vara 1?)
				[new_position, seg_plus] = ...
					choose_position(car.position, car.segment, car.num, car.pos_at);
				if seg_plus ~= 0 && car.segment == 2
					disp('Hoppar �ver missad givare 1/2');
				else
					car.position = new_position;
					car.segment = min(9, car.segment + seg_plus);
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
        disp(car)
	end

	%% NEW LAP
	if car.new_lap == true
		disp('NEW LAP')
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
            car.percents = fit_percents(car.percents, car.lap_times(car.lap), car.seg_times(car.lap,:));
            
			if car.automatic && car.lap == 1 && size(car.seg_times, 2) < 9
				disp('FEL: F�r f� segment!!')
				car.stopped = true;
				other_car.stopped = true;
				return
			end

			display_data = [display_data, put_text(100, 16 + (16 * car.num), 'L', strjoin({num2str(car.lap), get_time_as_string(round(car.lap_times(car.lap) * 1000))}, ' '))];

			car.segment = 1;
			car.lap = car.lap + 1;
        end
        disp(car)
	end
end

%% CALCULATE
if car.running == true && car.automatic == true
	car.v = get_new_v(car.position, car.map);
	car.u = car.v * car.constant;
end

%% CONTROLLER
if car.running == true && car.automatic == false
    mult_ = 100;
    max_ = 55;
    div_ = 55;
	set_car_speed(car.num, mult_ * ((max_ - get_manual_speed(car.num)) / div_))
end

%% EXECUTE
if car.running == true && car.automatic == true
	% disp(strjoin({num2str(car.num), num2str(car.u), num2str(car.position)}))
    if not(boot.status)
        set_car_speed(car.num, max(car.u, 16));
    else
        set_car_speed(car.num, car.u);
    end
end
end
