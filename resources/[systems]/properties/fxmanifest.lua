fx_version 'cerulean'
game 'gta5'

dependencies {
	'entities',
	'npcs',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'sh_config.lua',
	'sh_properties.lua',
	'sh_property.lua',
	'sh_npcs.lua',
}

client_scripts {
	'@npcs/client.lua',
	'@ui/scripts/cl_main.lua',
	'cl_main.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'@npcs/server.lua',
	'sv_main.lua',
}