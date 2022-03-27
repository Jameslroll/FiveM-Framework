function AppendText(text, append)
	if not text then return end
	if not append then
		error("no text to append ("..text..")")
	end
	if text ~= "" then
		text = text.." "
	end
	return text..append
end

function AppendLine(text, append, width)
	local len = text:len()
	if len < width then
		for i = len, width do
			text = text.." "
		end
	end
	return text..append
end