function bars = get_bars_from_values(values1, values2)
bars = [];
for i = 1:9
	bar = struct;
	bar.x_lo = 16 + 13 + (30 * i);
	bar.x_hi = bar.x_lo;
	bar.y_lo = 200;
	bar.y_hi = round(152 * (values1(i) / max(values1)));
	if isempty(values2)
		bar.x_hi = bar.x_lo + 20;
		bars = [bars bar1]
	else
		bar.x_hi = bar.x_lo + 10;
		bar2 = struct;
		bar2.x_lo = bar.x_lo + 10;
		bar2.x_hi = bar2.x_hi + 10;
		bar2.y_lo = 200;
		bar2.y_hi = round(152 * (values2(i) / max(values2)));
		bars = [bars bar1 bar2]
	end
end
end
