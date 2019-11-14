function [ack, start_code, responses] = get_response(display_data)
% GET RESPONSE
%	In-depth explanation
%	[flag, display_data] = matlabclient(2)

ack = false;
start_code = '';
responses = [];

if isempty(display_data)
    return
end
bcc = display_data(length(display_data));


pointer = 1;

if display_data(pointer) == 6
	ack = true;
else
	return
end

if pointer > length(display_data)
    return 
end

pointer = pointer + 1;
if display_data(1) == 17
	start_code = 'DC1';
elseif display_data(1) == 18
	start_code = 'DC2';
end

pointer = pointer + 1;
% total length

data = struct;
while pointer < length(display_data) - 1  % last value is bcc
    pointer = pointer + 1;
    if display_data(pointer) ~= 27
        % TODO: no ESC?
    end
    pointer = pointer + 1;
    data.id = char(display_data(pointer));
    
    pointer = pointer + 1;
    data.length = display_data(pointer);
    if data.id == 'A'
        pointer = pointer + 1;
        data.data = display_data(pointer);
    else
        pointer = pointer + data.length;
    end
    responses = [responses, data];
end
