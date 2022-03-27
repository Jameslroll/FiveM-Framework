fx_version 'adamant'
game 'gta5'

shared_scripts {
	'sh_config.lua',
	'sh_casino.lua',
	'games/**/sh_*.lua',
}

client_scripts {
	'@utils/client/misc.lua',
	'cl_casino.lua',
	'games/**/cl_*.lua',
}

server_scripts {
	'@utils/server/random.lua',
	'sv_casino.lua',
	'games/**/sv_*.lua',
}