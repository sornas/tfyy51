function num_as_str = get_time_as_string(millis)
%GET_TIME_AS_STRING Number of milliseconds, formatted mm:ss.s and rounded
%   Detailed explanation goes here
minutes = num2str(fix(millis / (1000*60)));
seconds = mod(millis, 1000*60);
seconds_str = sprintf('%02d', fix(seconds / 1000));
rest_str = num2str(round(mod(seconds, 1000), -2) / 100);
num_as_str = strjoin({minutes, ':', seconds_str, '.', rest_str}, '');
end

