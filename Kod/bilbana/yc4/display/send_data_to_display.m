function [] = send_data_to_display()
%SEND_DATA_TO_DISPLAY sends available data to display if last send was
%                     more than 0.5 seconds ago.
    persistent last_send;
    global display_data;
    
    if isempty(display_data)
        return
    end
    % disp(last_send);
    % disp(clock);
    if isempty(last_send)  % first send
        %% SEND DATA
        % disp('sending data');
        % disp(display_data)
        matlabclient(1, display_data{1});
        last_send = clock;
        display_data(1) = [];
    elseif (etime(clock, last_send) >= 0.5)
        %% SEND DATA
        % disp('sending data');
        % disp(display_data)
        matlabclient(1, display_data{1});
        last_send = clock;
        display_data(1) = [];
    end
end
