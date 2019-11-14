function pkg = define_bar_graph(direction, no, x1, y1, x2, y2, start_value, end_value, type, pattern)
pkg = []
if direction == 'left'
	direction = 'L'
elseif direction == 'right'
	direction = 'R'
elseif direction == 'up'
	direction == 'O'
elseif direction == 'down'
	direction = 'U'
else
	return

args = [no, get_bytes(x1), get_bytes(y1), get_bytes(x2), get_bytes(y2)]
args = [args, start_value, end_value, type, pattern]  %TODO get_bytes or no ?

pkg = get_package(strjoin({'B', direction}, ''), args)
end
