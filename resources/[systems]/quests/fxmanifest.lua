fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/**/*.html',
	'html/**/*.js',
	'html/**/*.css',
}

shared_scripts {
	'sh_quests.lua',
}

client_scripts {
	'cl_quests.lua',
}

server_scripts {
	'sv_quests.lua',
}