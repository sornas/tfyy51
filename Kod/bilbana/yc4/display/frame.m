function pkg = frame(x1, y1, x2, y2, n1)
arg = [get_bytes(x1), get_bytes(y1), get_bytes(x2), get_bytes(y2)];
pkg = get_package('RR', arg);
end
