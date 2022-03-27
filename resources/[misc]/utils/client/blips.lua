local skipBlipInfo = {
	["Colour"] = true
}

function SetBlipInfo(blip, data)
	for k, v in pairs(data) do
		if not skipBlipInfo[k] then
			local func = _G["SetBlip"..k]
			if func then
				func(blip, type(v) == "table" and table.unpack(v) or v)
			end
		end
	end

	if data.Name then
		if GetLabelText(data.Name) == "NULL" then
			AddTextEntry(data.Name, data.Name)
		end
		
		BeginTextCommandSetBlipName(data.Name)
		EndTextCommandSetBlipName(blip)
	end

	if data.Colour then
		SetBlipColour(blip, data.Colour)
	end
end