function pkg = set_display_visible(visible)
	if visible == true
		pkg = get_package('DE', []);
	else
		pkg = get_package('DA', []);
	end
end
