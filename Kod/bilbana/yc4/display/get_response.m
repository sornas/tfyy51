function [ack, start_code, data] get_response(display_data)
% GET RESPONSE
%	In-depth explanation
%	[flag, display_data] = matlabclient(2)

ack = false;
start_code = '';
data = [];

len = -1;

if display_data[0] == 6
	ack = true;
else
	return
end

display_data[0] = [];

if display_data[0] == 17
	start_code = 'DC1';
elseif display_data[0] == 18
	start_code = 'DC2';
end

display_data[0] = [];

len = display_data[0];

while len > 0
	
end

end
