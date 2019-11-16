function [] = verbose(tag, strings)
global log_verbose;
if log_verbose
    disp(strjoin({'VERBOSE (', tag, '): ', strings}, ''))
end
end
