fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'shared/config.lua',
	'shared/misc.lua',
	'shared/main.lua',
	'shared/characters.lua',
}

client_scripts {
	'@ui/scripts/cl_main.lua',
	'client/templates.lua',
	'client/main.lua',
	'client/characters.lua',
	'client/menu.lua',
	'client/commands.lua',
}

server_scripts {
	'@utils/server/date.lua',
	'@utils/server/database.lua',
	'server/queries.lua',
	'server/main.lua',
	'server/modules.lua',
	'server/clients.lua',
	'server/characters.lua',
}