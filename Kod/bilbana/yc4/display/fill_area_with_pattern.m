function pkg = fill_area_with_pattern(x1, y1, x2, y2, n1)
arg = [get_bytes(x1), get_bytes(y1), get_bytes(x2), get_bytes(y2), n1];
pkg = get_package('RM', arg);
end
