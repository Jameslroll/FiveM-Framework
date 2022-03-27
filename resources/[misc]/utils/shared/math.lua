function Lerp(a, b, t)
	return a + math.min(math.max(t, 0), 1) * (b - a)
end