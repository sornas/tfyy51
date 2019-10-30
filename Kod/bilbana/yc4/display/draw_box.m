function pkg = draw_box(x1, y1, x2, y2, n1)
% rectangle with pattern filled and solid line around it
	arg = [get_bytes(x1), get_bytes(y1), get_bytes(x2), get_bytes(y2), n1];

	pkg = get_package('RO', arg);
end
