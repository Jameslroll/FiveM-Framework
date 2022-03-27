fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/sounds/*.ogg'
}

client_scripts {
	'cl_sound.lua',
}

server_scripts {
	'@utils/server/players.lua',
	'sv_sound.lua',
}