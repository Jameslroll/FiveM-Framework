fx_version 'adamant'
game 'gta5'

ui_page 'dist/index.html'

files {
	'dist/css/*.css',
	'dist/js/*.js',
	'dist/img/*.png',
	'dist/fonts/*.ttf',
	'dist/index.html',
}

dependencies {
	'yarn',
	'webpack',
}

shared_scripts {
	'scripts/sh_config.lua',
	'scripts/sh_chat.lua',
}

client_scripts {
	'scripts/cl_chat.lua',
	'scripts/cl_menu.lua',
	'scripts/cl_commands.lua',
}

server_scripts {
	'scripts/sv_chat.lua',
	'scripts/sv_commands.lua',
}