function car = init_car(track_number)

car = struct();

% Car state
car.state = 'intro';

% Track number
car.track_number = track_number;

% Current track segment
car.position = 0;

% Current lap
car.lap = 0;

% Start race timer
car.t0 = tic();

% Control signal
car.control = nan(1,1);
car.control_log_time = nan(1,1);
car.control_log_position = zeros(1,1);

end