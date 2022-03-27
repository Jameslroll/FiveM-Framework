fx_version 'cerulean'
game 'gta5'

dependencies {
	'interact',
}

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'cl_bell.lua',
}

server_scripts {
	'@utils/server/players.lua',
	'@utils/server/random.lua',
	'sv_bell.lua',
}