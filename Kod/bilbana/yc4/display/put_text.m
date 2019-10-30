function [pkg] = put_text(x, y, justification, text)
	code = strjoin({'Z', justification}, '');

	arg1 = [mod(x, 256), x ./ 256, mod(y, 256), y ./ 256];
	arg2 = text;
	arg3 = 0;

	pkg = get_package(code, [arg1 double(arg2) arg3]);
end
