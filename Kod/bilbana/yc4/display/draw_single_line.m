function [pkg] = draw_line(x1, y1, x2, y2)
	arg = [x1, 0, y1, 0, x2, 1, y2, 0]  % TODO nollor mellan värden? vad betyder ettan?

	pkg = get_package('GD', arg)
end
