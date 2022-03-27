local Getters = {}

Character = {}
Character.__index = Character

--[[ Functions ]]--
function Character:Destroy()
	Main.ids[self.id] = nil
end

function Character:Get(key)
	return self[key]
end

function Character:GetName()
	return ("%s %s"):format(self.first_name or "", self.last_name or "")
end

function Character:GetHours()
	return (self.time_played or 0) / 3600.0
end

function Character:GetPosition()
	return vector3(self.pos_x or 0.0, self.pos_y or 0.0, self.pos_z or 0.0)
end