function pkg = define_bar_graph(num, keep_visible)
if keep_visible
	keep_visible = 1
else
	keep_visible = 0
pkg = get_package('BD', [num, keep_visible])
end
