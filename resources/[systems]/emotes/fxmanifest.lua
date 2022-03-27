fx_version 'cerulean'
game 'gta5'

dependencies {
	'chat',
	'interact',
}

files {
	'animations.txt',
}

shared_scripts {
	'sh_config.lua',
	'sh_groups.lua',
	'sh_main.lua',
}

client_scripts {
	'@utils/client/entities.lua',
	'@utils/client/misc.lua',
	'@utils/client/vectors.lua',
	'@ui/scripts/cl_main.lua',
	'cl_main.lua',
	'cl_navigation.lua',
	'cl_emotes.lua',
	'cl_movement.lua',
	'cl_commands.lua',
	'cl_animations.lua',
	'cl_sync.lua',
}

server_scripts {
	'@utils/server/players.lua',
	'sv_emotes.lua',
}
