function Debug(...)
	if not Config.Debug then return end

	Print(...)
end

function Print(text, ...)
	if #{...} > 0 then
		print(tostring(text):format(...))
	else
		print(tostring(text))
	end
end

function RegisterItem(item)
	Inventory:RegisterItem(item)
end

function RegisterRecipe(recipe)
	Inventory:RegisterRecipe(recipe)
end

function Equals(a, b)
	local typeA = type(a)
	local typeB = type(b)

	if a == nil and a ~= b then
		return false
	elseif (
		typeA == "number" and
		math.abs((a or 0.0) - (b or 0.0)) > 0.000001
	) then
		return false
	elseif typeA == "string" then
		return a == b
	elseif typeA == "table" then
		if typeB == "string" then
			b = json.decode(b)
		end
		for k, v in pairs(a) do
			if b == nil or not Equals(v, b[k]) then
				return false
			end
		end
	end

	return true
end

function FormatName(name)
	return name:gsub("%s+", ""):lower()
end

function FormatSpaces(text)
	return text:gsub("%s+", "") 
end