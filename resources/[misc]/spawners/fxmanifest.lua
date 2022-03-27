fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'sh_config.lua',
	'sh_spawners.lua',
}

client_scripts {
	'cl_spawners.lua',
}

server_scripts {
	'@utils/server/random.lua',
	'sv_spawners.lua',
}