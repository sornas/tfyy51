clear all;

addpath display/ClientServerApp/Release
cd display/ClientServerApp/Release
!startServer
cd ../../..

pause(1);

matlabclient(1, get_smallpackage([ ...
		key(0  , 216, 107, 240, 51, 61, 'C', 'Varv'), ...
		key(107, 216, 213, 240, 52, 62, 'C', 'Segment'), ...
		key(213, 216, 320, 240, 53, 63, 'C', 'Avsluta') ...
]));
pause(0.2);

%% CHECK DISPLAY BUTTONS
display.last_check = tic;
done = false;

laptime_1 = [12 12.1 12.2 12.3 12.4 12.5 12.6 12.7 12.8 12.9 13];
laptime_2 = [11 11.2 11.4 11.6 11.8 12 12.5 13 13.5 14 14.2 14.6 14.8 15];

while 1
	pause(0.1);
	if toc(display.last_check) > 0.4
		display.last_check = tic;

		% read internal mem from last send
		[display.out, display.shm] = matlabclient(2);
		[display.shm_interp.ack, display.shm_interp.start_code, display.shm_interp.data] = get_response(display.shm);

		% request internal mem
		matlabclient(1, hex2dec(['12'; '01'; '53'; '66']));
		if isempty(display.shm_interp.data)
			continue;
		end
		update_ref_time = false;
		for i = 1:length(display.shm_interp.data)
			disp(num2str(length(display.shm_interp.data)))
			data = display.shm_interp.data(i);
			if data.data == 51
				draw_lap_graph(laptime_1, laptime_2, 13, false);
			elseif data.data == 52
				draw_segment_bars([1 2 3 4 5 6 7 8 9], [9 8 7 6 5 4 3 2 1]);
			elseif data.data == 53
				pause(0.2);
				matlabclient(1, get_smallpackage(clear_display()));
				pause(0.2);
				done = true;
			elseif data.data == 70
				draw_lap_graph(laptime_1, laptime_2, 13, true);
			end
		end
		if done == true
			break
		end
		if update_ref_time == true
			pause(0.4);
			matlabclient(1, get_smallpackage(put_text(160, 120, 'C', num2str(ref_time, '%.1f'))));
		end
		display.last_check = tic;
	end
end

matlabclient(3);
