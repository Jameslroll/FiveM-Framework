Main = Main or {}
Main.event = GetCurrentResourceName()..":"

function FormatText(text)
	return text:gsub("[<>%c]", function(match)
		return Config.Replacers[match] or ""
	end)
end