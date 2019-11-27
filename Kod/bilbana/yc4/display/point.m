function pkg = point(x1, y1)
arg = [get_bytes(x1), get_bytes(y1)];
pkg = get_package('GP', arg);
end
