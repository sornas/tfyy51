function [] = setup_car(car, track)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp('J = Ja (automatiskt), M = Ja (manuellt), N = Nej');

car.response = input('Vill du köra bil 1? [N] ', 's');
if car.response == 'J'
	car.running = true;
	car.automatic = true;
elseif car.response == 'M'
	car.running = true;
	car.automatic = false;
else
	car.running = false;
end
end

