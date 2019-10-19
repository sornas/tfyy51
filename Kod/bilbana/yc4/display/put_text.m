function [pkg] = put_text(x, y, justification, text)
	code = double(join('Z', justification))

	arg1 = [x, 0, y, 0]
	arg2 = text;
	arg3 = 0;

	pkg = get_package(join('Z', justification), [arg1 arg2 arg3])
end
