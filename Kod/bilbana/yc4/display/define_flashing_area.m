function pkg = define_flashing_area(x1, y1, x2, y2)
	arg = [get_bytes(x1), get_bytes(y1), get_bytes(x2), get_bytes(y2)];

	pkg = get_package('QI', arg);
end
