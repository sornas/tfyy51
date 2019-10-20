function [pkg] = put_text(x, y, justification, text)
	code = double(strjoin({'Z', justification}, ''));

	arg1 = [x, 0, y, 0];
	arg2 = text;
	arg3 = 0;

	pkg = get_package(code, [arg1 double(arg2) arg3]);
end
