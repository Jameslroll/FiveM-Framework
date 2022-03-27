fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/**/*.html',
	'html/**/*.js',
	'html/**/*.css',
	'html/fonts/*.ttf',
	'html/assets/*.png',
	'html/assets/*.jpg',
}

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'@grids/shared/grids.lua',
	'cl_misc.lua',
	'cl_drawing.lua',
	'cl_interactable.lua',
	'cl_interact.lua',
	'cl_navigation.lua',
}

server_scripts {
	'sv_interact.lua',
}