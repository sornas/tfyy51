function [] = debug(tag, strings)
global log_debug;
if log_debug
    disp(strjoin({'DEBUG (', tag, '): ', strings}, ''))
end
end
