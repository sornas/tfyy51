function bytes = get_bytes(num)
bytes = [mod(num, 256), fix(num / 256)];
end
