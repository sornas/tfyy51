function car = update_control(new_control_signal, car_in)

% Return track struct
car = car_in;

% Update track struct
car.control(end+1) = new_control_signal;
car.control_log_time(end+1) = toc(car.t0);
car.control_log_position(end+1) = car.position;

% Update speed
set_car_speed(car.track_number, car.control(end));

end


