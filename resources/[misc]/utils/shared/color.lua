function HexToRgb(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

function RgbToHex(r, g, b)
	local rgb = (r * 0x10000) + (g * 0x100) + b
	return string.format("%x", rgb)
end

function RgbToLuminance(r, g, b)
	return (0.299 * r + 0.587 * g + 0.114 * b) / 255.0
end