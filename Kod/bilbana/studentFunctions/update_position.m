function [car, gateway_passed] = update_position(car_in)

car = car_in;

[lap_car, chk_pnt, time] = get_car_position(car.track_number);

if lap_car == true
    % New lap
    
    % Update position on track
    car.position = 1;
    
    % Add lap to lap counter
    car.lap = car.lap + 1;
    
    % Update gw passed
    gateway_passed = true;
    
    % Make sound
    beep;
    
elseif chk_pnt == true && car.position ~= 0
    % CP passed
    
    % Update position
    car.position = car.position + 1;
    
    % update gw passed
    gateway_passed = true;
    
    % Make sound
    beep;
    
else
    gateway_passed = false;
    
end

end