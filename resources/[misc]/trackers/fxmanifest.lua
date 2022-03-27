fx_version 'adamant'
game 'gta5'

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'@utils/client/blips.lua',
	'cl_groups.lua',
	'cl_trackers.lua',
}

server_scripts {
	'@utils/server/players.lua',
	'sv_groups.lua',
	'sv_trackers.lua',
}