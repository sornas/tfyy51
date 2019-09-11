function car = car_controller(car_in)

car = car_in;

% Read sensors
[car, cp_passed] = update_position(car);

if cp_passed
    % Update speed
    
    new_control = car.control(end) + 0.5*(rand() - 0.5); % Temporary control policy
    
    car = update_control(new_control, car);
end

end