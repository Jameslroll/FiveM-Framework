Queue = {
	add = {},
	remove = {},
}

function Queue:Add(data)
	table.insert(self.add, data)
end

function Queue:Remove(id)
	table.insert(self.remove, id)
end

function Queue:Update()
	local add = self.add[1]
	if add then
		if add.id and not Main.decorations[add.id] then
			Decoration:Create(add)
		end
		table.remove(self.add, 1)
	end

	local remove = self.remove[1]
	if remove then
		local decoration = Main.decorations[remove]
		if decoration then
			decoration:Destroy()
		end
		table.remove(self.remove, 1)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Queue:Update()
		Citizen.Wait(5)
	end
end)