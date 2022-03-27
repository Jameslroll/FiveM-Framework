local texts = {}
local sets = {}
local snowflake = 0
local bones = {
	["pelvis"] = 0x2E28,
	["lthigh"] = 0xE39F,
	["lcalf"] = 0xF9BB,
	["lfoot"] = 0x3779,
	["rthigh"] = 0xCA72,
	["rcalf"] = 0x9000,
	["rfoot"] = 0xCC4D,
	["spine0"] = 0x5C01,
	["spine1"] = 0x60F0,
	["spine2"] = 0x60F1,
	["spine3"] = 0x60F2,
	["lclavicle"] = 0xFCD9,
	["lupperarm"] = 0xB1C5,
	["lforearm"] = 0xEEEB,
	["lhand"] = 0x49D9,
	["rclavicle"] = 0x29D2,
	["rupperarm"] = 0x9D4D,
	["rforearm"] = 0x6E5C,
	["rhand"] = 0xDEAD,
	["neck"] = 0x9995,
	["head"] = 0x796E,
}

--[[ Functions ]]--
local function UpdateText(entity)
	local lastTexts = texts[entity]
	if lastTexts then
		for k, id in ipairs(lastTexts) do
			exports.interact:RemoveText(id)
		end
		texts[entity] = nil
	end

	local set = sets[entity]
	if not set then return end

	if #set == 0 then
		sets[entity] = nil
		texts[entity] = nil

		return
	end

	local preText = [[
		<div style='
			display: flex;
			position: absolute;
			flex-direction: column;
			align-items: center;
			bottom: 0%;
			width: 40vmin;
			height: auto;
			transform: translate(-50%, 0%);
		'>
	]]

	local interacts = {}
	for k, _text in ipairs(set) do
		local bone = bones[_text.text:match("(%w+)(.+)") or false] or false
		local interactText = interacts[bone] or preText

		interacts[bone] = interactText..[[
			<div style='
				display: flex;
				position: relative;
				width: auto;
				height: auto;
				font-size: 1.2em;
				white-space: pre-line;
				word-break: break-word;
				word-wrap: break-word;
				background: rgba(0, 0, 0, 0.6);
				border-radius: 8px;
				padding: 6px;
				margin-top: 4px;
			'>]]..(bone and _text.text:gsub("^.-%s", "", 1) or _text.text)..[[</div>
		]]
	end

	local _texts = {}
	texts[entity] = _texts

	for bone, text in pairs(interacts) do
		_texts[#_texts + 1] = exports.interact:AddText({
			bone = bone or 0x796E,
			entity = entity,
			offset = not bone and vector3(0.0, 0.0, 0.22) or nil,
			distance = 40.0,
			text = text.."</div>",
			transparent = true,
		})
	end

end

function AddText(entity, text, duration)
	local set = sets[entity]
	if not set then
		set = {}
		sets[entity] = set
	end

	snowflake = snowflake + 1
	local _snowflake = snowflake

	table.insert(set, {
		text = text,
		snowflake = _snowflake,
	})

	UpdateText(entity)
	
	if not duration then return end

	Citizen.SetTimeout(math.floor(duration), function()
		set = sets[entity]
		if not set then return end

		for k, _text in ipairs(set) do
			if _text.snowflake == _snowflake then
				table.remove(set, k)
				UpdateText(entity)
				break
			end
		end
	end)
end

--[[ Exports ]]--
exports("AddText", function(...)
	AddText(...)
end)

--[[ Events: Net ]]--
RegisterNetEvent("players:me", function(netId, text, distance)
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not entity or not DoesEntityExist(entity) then return end

	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	local coords = GetEntityCoords(entity)

	if #(pedCoords - coords) < distance then
		AddText(entity, text, 10000 + (text:len() / 256) * 10000)
	end
end)