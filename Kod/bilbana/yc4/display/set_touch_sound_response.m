function pkg = set_touch_sound_response(state)
	if state == true
		pkg = get_package('AS', [1]);
	else
		pkg = get_package('AS', [0]);
	end
end
