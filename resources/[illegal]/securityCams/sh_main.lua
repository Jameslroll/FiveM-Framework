EventName = GetCurrentResourceName()..":"

Main = {
	models = {},
	sites = {},
}

--[[ Functions ]]--
function Main:IsObjectACamera(entity)
	-- Does exist.
	if not DoesEntityExist(entity) then return false end

	-- Get model.
	local hash = GetEntityModel(entity)

	-- Check hash.
	return self.models[hash] ~= nil
end

function Main:GetCameraSettings(entity)
	-- Get model.
	local hash = GetEntityModel(entity)
	local model = self.models[hash]
	if model == nil then return end

	-- Get settings.
	return Config.Cameras[model]
end

--[[ Init ]]--
for model, settings in pairs(Config.Cameras) do
	Main.models[GetHashKey(model)] = model
end