fx_version 'cerulean'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/*.css',
	'html/*.html',
	'html/*.js',
	'html/images/*.png',
	'html/fonts/*.ttf',
}

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'cl_main.lua',
}

server_scripts {
	'sv_main.lua',
}