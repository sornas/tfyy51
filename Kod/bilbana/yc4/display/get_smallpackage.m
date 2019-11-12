function pkg = get_smallpackage(data)
	DC1 = 17;

	len = length(data);
	initStr = [DC1, len, data];
	bcc = mod(sum(initStr), 256);
	pkg = [initStr, bcc];
end
