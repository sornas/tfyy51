function [pkg] = put_text(x, y, justification, text)
arg1 = [get_bytes(x), get_bytes(y)];
arg2 = text;
arg3 = 0;

pkg = get_package(strjoin({'Z', justification}, ''),  [arg1 double(arg2) arg3]);
end
