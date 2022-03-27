Wheel = {}

function Wheel:Init()
	RequestStreamedTextureDict("CasinoUI_Lucky_Wheel", false)
end

function Wheel:Update(objects)
	for k, object in ipairs(objects) do
		if GetEntityModel(object) == -1901044377 then
			
		end
	end
	return 1000
end

Casino:Register(Wheel)