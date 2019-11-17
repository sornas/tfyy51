function pkg = bar_graph(direction, no, x1, y1, x2, y2, start_value, end_value, type, pattern)
pkg = []
args = [no, get_bytes(x1), get_bytes(y1), get_bytes(x2), get_bytes(y2)]
args = [args, start_value, end_value, type, pattern]  %TODO get_bytes or no ?

pkg = get_package(strjoin({'B', direction}, ''), args)
end
