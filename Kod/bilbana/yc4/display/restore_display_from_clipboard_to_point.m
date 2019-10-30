function pkg = restore_display_from_clipboard_to_point(x1, y1)
	arg = [get_bytes(x1), get_bytes(y1)];

	pkg = get_package('CK', arg);
end
