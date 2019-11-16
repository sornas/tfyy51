function num_as_str = get_time_as_string(millis)
%GET_TIME_AS_STRING Number of milliseconds, formatted mm:ss.s and rounded
%   Detailed explanation goes here
minutes = fix(millis / (1000*60));
seconds = mod(millis, 1000*60);
rest = round(mod(seconds, 1000), -2) / 100;
if rest == 10
    seconds = seconds + 1*1000;
    rest = 0;
end
minutes_str = num2str(minutes);
seconds_str = sprintf('%02d', fix(seconds / 1000));
rest_str = num2str(rest);
num_as_str = strjoin({minutes_str, ':', seconds_str, '.', rest_str}, '');
end

