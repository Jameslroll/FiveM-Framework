fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'@grids/shared/grids.lua',
	'sh_config.lua',
}

client_scripts {
	'@utils/client/entities.lua',
	'@utils/client/misc.lua',
	'@utils/client/vectors.lua',
	'cl_lootables.lua',
}

server_scripts {
	'@utils/server/players.lua',
	'@utils/server/random.lua',
	'sv_lootables.lua',
}