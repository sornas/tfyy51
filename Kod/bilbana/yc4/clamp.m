function val = clamp(m, n, M)
% returns n if n is between m and M, otherwise
	% m if n < m
	% M if n > m
val = min(max(m, n), N)
end
