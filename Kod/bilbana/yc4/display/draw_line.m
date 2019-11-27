function pkg = draw_line(x1, y1, x2, y2)
arg = [mod(x1, 255), fix(x1 / 255), y1, 0, mod(x2, 255), fix(x2 / 255), y2, 0];
pkg = get_package('GD', arg);
end
