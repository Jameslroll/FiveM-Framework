fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/**.html',
	'html/**.js',
	'html/**.css',
	'html/assets/*.png',
	'html/assets/*.gif',
}

shared_scripts {
	'sh_config.lua',
	'sh_misc.lua',
	'sh_main.lua',
}

client_scripts {
	'@utils/client/entities.lua',
	'cl_menu.lua',
	'cl_main.lua',
	'cl_sites.lua',
	'cl_groups.lua',
	'cl_cameras.lua',
	'cl_doors.lua',
	'cl_commands.lua',
	'cl_debug.lua',
}

server_scripts {
	'sv_main.lua',
}