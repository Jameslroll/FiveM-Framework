fx_version 'bodacious'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.css',
	'html/index.js',
	'html/assets/*.png',
}

shared_scripts {
	'sh_config.lua',
	'sh_voip.lua',
}

client_scripts {
	'@utils/client/entities.lua',
	'@utils/client/vehicles.lua',
	'cl_voip.lua',
	'cl_clients.lua',
	'cl_commands.lua',
}

server_scripts {
	'sv_voip.lua',
	'sv_clients.lua',
	'sv_channels.lua',
}