fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/**/*.html',
	'html/**/*.css',
	'html/**/*.js',
	'html/assets/sounds/*.ogg',
	'html/assets/fonts/*.ttf',
	'html/assets/images/*.png',
}

shared_script {
	'sh_config.lua',
}

client_scripts {
	'cl_dispatch.lua',
}

server_scripts {
	'sv_dispatch.lua',
}