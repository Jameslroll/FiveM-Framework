function Export(context, name)
	exports(name, function(...)
		return context[name](context, ...)
	end)
end