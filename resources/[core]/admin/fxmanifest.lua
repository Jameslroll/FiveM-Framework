fx_version 'bodacious'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.js',
}

dependencies {
	'trackers',
	'yarn',
	'chat',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'sh_config.lua',
	'sh_admin.lua',
	'modules/**/sh_*.lua',
}

server_scripts {
	'@utils/server/date.lua',
	'@utils/server/players.lua',
	'sv_admin.lua',
	'sv_commands.lua',
	'modules/**/sv_*.lua',
	'node/index.js',
}

client_scripts {
	'@camera/cl_camera.lua',
	'@ui/scripts/cl_main.lua',
	'@utils/client/entities.lua',
	'@utils/client/misc.lua',
	'@utils/client/scenarios.lua',
	'@utils/client/vectors.lua',
	'@utils/client/vehicles.lua',
	'cl_admin.lua',
	'cl_nui.lua',
	'cl_menu.lua',
	'cl_commands.lua',
	'modules/**/cl_*.lua',
}