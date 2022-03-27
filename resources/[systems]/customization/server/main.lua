--[[ Functions ]]--
function UpdateAppearance(source, appearance, features)
	if not exports.character:IsSelected(source) then
		return false, "No character"
	end

	local data = {}
	local cost = 0

	if appearance then
		if not ValidateTable(appearance) then
			return false, "Invalid features"
		end

		local _appearance = exports.character:Get(source, "appearance")
		
		-- TODO: cost

		data.appearance = appearance
	end

	if features then
		if not ValidateTable(features) then
			return false, "Invalid appearance"
		end

		local _features = exports.character:Get(source, "features")

		-- TODO: cost

		data.features = features
	end

	-- TODO: take money
	
	exports.character:Set(source, data)

	return true
end

function ValidateTable(table)
	if type(table) ~= "table" then
		return false
	end

	for k, v in pairs(table) do
		local vType = type(v)

		if vType == "table" then
			if not ValidateTable(v) then
				return false
			end
		elseif vType ~= "number" then
			return false
		end
	end

	return true
end

--[[ Events ]]--
RegisterNetEvent("customization:update", function(appearance, features)
	local source = source
	local retval, result = UpdateAppearance(source, appearance, features)

	if IsDebug then
		print("updating", retval, result)
		print("appearance", json.encode(appearance))
		print("features", json.encode(features))
	end

	TriggerClientEvent("customization:saved", source, retval, result)
end)