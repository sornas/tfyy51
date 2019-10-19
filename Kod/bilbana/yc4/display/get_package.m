function [pkg] = get_package(code, args)
	DC1 = 17;
	ESC = 27;

	data = [ESC, double(code), args];
	len = length(data);
	initStr = [DC1, len, data];
	bcc = mod(sum(initStr), 256);
	pkg = [initStr, bcc];
end
