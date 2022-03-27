fx_version 'adamant'
game 'gta5'

shared_scripts {
	'sh_config.lua',
	'sh_fishing.lua',
}

client_scripts {
	'cl_fishing.lua',
}

server_scripts {
	'@utils/server/random.lua',
	'sv_fishing.lua',
}