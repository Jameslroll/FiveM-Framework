-- Valid flags: 1-63
FlagEnums = {
	["IS_OWNER"] = 1,
	["IS_ADMIN"] = 2,
	["IS_MOD"] = 3,
	["IS_DEV"] = 4,
	
	["CAN_PLAY_ANIMAL"] = 5,
	["CAN_PLAY_PEDS"] = 6,

	["POOR_ROLEPLAY"] = 31,
	["POSSIBLE_CHEATER"] = 32,
}

function Main:GetFlags()
	return FlagEnums
end
Export(Main, "GetFlags")

function User:HasFlag(flag)
	if not self.flags then
		return false
	end

	if type(flag) == "string" then
		flag = FlagEnums[flag]
	end

	if type(flag) ~= "number" then
		return false
	end

	local mask = 1 << flag

	return self.flags & mask ~= 0
end

function User:IsMod()
	if not self.flags then
		return false
	end

	return (self.flags & (1 << 1) | self.flags & (1 << 2) | self.flags & (1 << 3)) ~= 0
end

function User:IsAdmin()
	if not self.flags then
		return false
	end

	return (self.flags & (1 << 1) | self.flags & (1 << 2)) ~= 0
end

function User:IsOwner()
	if not self.flags then
		return false
	end

	return self.flags & (1 << 1) ~= 0
end

function User:IsDev()
	if not self.flags then
		return false
	end

	return (self.flags & (1 << 1) | self.flags & (1 << 4)) ~= 0
end