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
				draw_lap_graph([13 13 13.2 13.1 13 12.9 12.75], [], 13, false);
			elseif data.data == 52
				draw_segment_bars([1 2 3 4 5 6 7 8 9], []);
			elseif data.data == 53
				pause(0.2);
				matlabclient(1, get_smallpackage(clear_display()));
				pause(0.2);
				done = true;
			elseif data.data == 70
				draw_lap_graph([13 13 13.2 13.1 13 12.9 12.75], [], 13, true);
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
