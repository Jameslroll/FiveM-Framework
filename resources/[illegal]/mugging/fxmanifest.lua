fx_version 'adamant'
game 'gta5'

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'@utils/client/entities.lua',
	'@utils/client/misc.lua',
	'@utils/client/vectors.lua',
	'cl_mugging.lua',
	'cl_peds.lua',
	'cl_actions.lua',
}

server_scripts {
	'@utils/server/random.lua',
	'sv_mugging.lua',
	'sv_actions.lua',
}