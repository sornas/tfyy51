function pkg = get_package(code, args)
	ESC = 27;
	pkg = [ESC, double(code), args];
end
