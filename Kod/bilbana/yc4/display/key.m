function pkg = key(x1, y1, x2, y2, down_code, up_code, just, text)
arg_location = [get_bytes(x1), get_bytes(y1), get_bytes(x2), get_bytes(y2)];
arg_text = double(strjoin({just; text}, ''));
arg_null = 0;

pkg = get_package('AT', [arg_location, down_code, up_code, arg_text, arg_null]);
end
