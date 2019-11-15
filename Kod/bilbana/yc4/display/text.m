function [pkg] = text(x, y, justification, text)
arg1 = [mod(x, 256), x ./ 256, mod(y, 256), y ./ 256];
arg2 = strrep(text, '\n', '|');
arg3 = 0;

pkg = get_package(strjoin({'Z', justification}, ''),  [arg1 double(arg2) arg3]);
end
