fx_version 'adamant'
game 'gta5'

shared_scripts {
	'config/config.lua',
	'config/doors.lua',
	'config/groups.lua',
	'shared/*.lua',
}

client_scripts {
	'@utils/client/entities.lua',
	'@utils/client/vectors.lua',
	'client/*.lua',
}

server_scripts {
	'@utils/server/players.lua',
	'server/*.lua',
}