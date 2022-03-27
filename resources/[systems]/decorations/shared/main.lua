Decorations = {}

Main = {}
Main.event = GetCurrentResourceName()..":"
Main.grids = {}
Main.decorations = {}

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

function Register(name, data)
	Decorations[name] = data
end