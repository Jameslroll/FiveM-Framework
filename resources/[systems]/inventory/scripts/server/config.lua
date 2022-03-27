Server = {
	Tables = {
		Items = "items",
		Containers = "containers",
		Slots = "slots",
	},
	Queries = {
		GetSlotId = "SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=@schema AND TABLE_NAME=@table",
		UpdateSlot = "INSERT INTO `%s` SET %s ON DUPLICATE KEY UPDATE %s",
	},
	Containers = {
		Properties = {
			"id",
			"sid",
			"character_id",
			"vehicle_id",
			"property_id",
			"decoration_id",
			"slot_id",
		},
	},
	Slots = {
		Properties = {
			"container_id",
			"durability",
			"fields",
			"item_id",
			"nested_container_id",
			"quantity",
			"slot_id",
		},
	},
	Players = {
		Default = {
			{ Name = "Debit Card", Quantity = 1 },
			{ Name = "Mobile Phone", Quantity = 1 },
			{ Name = "Bills", Quantity = 200 },
			{ Name = "License", Quantity = 1, Fields = function(player)
				local source = player.source
				if source == nil then return end

				return {
					["Character"] = exports.character:Get(source, "id"),
					["Name"] = exports.character:GetName(source),
					["ID"] = exports.character:Get(source, "license_text"),
				}
			end },
		},
	},
}