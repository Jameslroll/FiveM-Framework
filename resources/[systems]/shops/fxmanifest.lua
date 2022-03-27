fx_version 'cerulean'
game 'gta5'

dependencies {
	'decorations',
	'inventory',
	'npcs',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'sh_templates.lua',
	'sh_config.lua',
	'sh_shops.lua',
	'shops/*.lua',
}

client_scripts {
	'@ui/scripts/cl_main.lua',
	'@npcs/client.lua',
	'cl_shops.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'@utils/server/players.lua',
	'@npcs/server.lua',
	'sv_shops.lua',
	'sv_commands.lua',
}