fx_version 'cerulean'
game 'gta5'

ui_page 'html/index.html'

dependencies {
	'players',
}

files {
	'html/**/*.css',
	'html/**/*.html',
	'html/**/*.js',
	'html/**/*.png',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'@utils/shared/math.lua',
	'sh_config.lua',
	'sh_health.lua',
	'modules/sh_*.lua',
}

client_scripts {
	'@camera/cl_camera.lua',
	'@npcs/client.lua',
	'@ui/scripts/cl_main.lua',
	'@utils/client/vectors.lua',
	'@utils/client/vehicles.lua',
	'cl_health.lua',
	'cl_bones.lua',
	'cl_injury.lua',
	'cl_treatment.lua',
	'cl_menu.lua',
	'cl_history.lua',
	'cl_respawn.lua',
	'modules/cl_*.lua',
}

server_scripts {
	'@npcs/server.lua',
	'@utils/server/players.lua',
	'sv_health.lua',
	'sv_players.lua',
	'sv_commands.lua',
	'sv_respawn.lua',
	'modules/sv_*.lua',
}
