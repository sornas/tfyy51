function bytes = get_bytes(num):
	bytes = [mod(num, 256), num ./ 256];
end
