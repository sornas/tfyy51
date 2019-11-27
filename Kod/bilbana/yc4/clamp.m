function val = clamp(n, m, M)
% returns n if n is between m and M, otherwise
	% m if n < m
	% M if n > m
val = min(max(n, m), M);
end
