fx_version 'adamant'
game 'gta5'

dependencies {
	'main',
}

shared_scripts {
	'shared/config.lua',
	'shared/main.lua',
	'shared/users.lua',
	'shared/flags.lua',
}

client_scripts {
	'client/main.lua',
	'client/users.lua',
	'client/flags.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'server/config.lua',
	'server/misc.lua',
	'server/main.lua',
	'server/users.lua',
	'server/flags.lua',
	'server/queue.lua',
	'server/commands.lua',
}