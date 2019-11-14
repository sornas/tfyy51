function pkg = set_drawing_mode(n1)
% 1 = set
% 2 = delete (erase)
% 3 = invert (on -> off, off -> on for every pixel thats drawn over)
pkg = get_package('GV', [n1]);
end
