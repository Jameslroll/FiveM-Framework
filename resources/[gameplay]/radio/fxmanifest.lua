fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.js',
	'html/index.css',
	'html/fonts/*.ttf',
	'html/sound/**/*.ogg',
	'html/assets/*.png',
}

-- shared_scripts {
-- 	'sh_config.lua',
-- 	'sh_radio.lua',
-- }

client_scripts {
	'cl_config.lua',
	'cl_radio.lua',
	'cl_commands.lua',
}

server_scripts {
	'sv_radio.lua',
}