function [bars, max_val, min_y, height] = get_bars_from_values(values1, values2)
bars = [];

% CONSTANT VALUES
min_y = 200;
height = 156;
min_x = 16+13;
bar_width = 10;  % for a single bar, doubled if only one track
bar_inner_gap_width = 1;  % double effect
bar_gap_width = 10;

% switch 1 and 2 if 1 is empty
if isempty(values1) && ~isempty(values2)
    values1 = values2;
    values2 = [];
end

max1 = max(values1);
max2 = 0;
if ~isempty(values2)
    max2 = max(values2);
end
max_val = max([max1 max2]);

for i = 1:9
	bar = struct;
	bar.x_lo = min_x + ((bar_width + bar_width + bar_gap_width) * (i-1));
	bar.x_hi = bar.x_lo;
	bar.y_lo = min_y;
	bar.y_hi = min_y - round(height * (values1(i) / max_val));
	if isempty(values2)
		bar.x_hi = bar.x_lo + 2*bar_width;
		bars = [bars bar];
	else
		bar.x_hi = bar.x_lo + bar_width;
		bar2 = struct;
		bar2.x_lo = bar.x_hi + bar_inner_gap_width*2;
		bar2.x_hi = bar2.x_lo + bar_width;
		bar2.y_lo = min_y;
		bar2.y_hi = min_y - round((height * (values2(i) / max_val)));
		bars = [bars bar bar2];
	end
end
end
