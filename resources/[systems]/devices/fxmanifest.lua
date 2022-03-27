fx_version 'cerulean'
game 'gta5'

ui_page 'dist/spa/index.html'

files {
	'dist/spa/index.html',
	'dist/spa/**.css',
	'dist/spa/**.js',
	'dist/spa/**.png',
	'dist/spa/**.woff',
	'dist/spa/**.woff2',
	'dist/spa/**.ogg',
	'apps/**/*.vue',
}

shared_scripts {
	'@jobs/flags.lua',
	'scripts/shared/config.lua',
	'scripts/shared/main.lua',
}

client_scripts {
	'scripts/client/main.lua',
	'scripts/client/commands.lua',
	'scripts/client/device.lua',
	'scripts/client/apps.lua',
	'scripts/client/notifications.lua',
	'scripts/client/calls.lua',
	'apps/**/cl_*.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'@utils/server/players.lua',
	'@utils/server/random.lua',
	'scripts/server/main.lua',
	'scripts/server/phone.lua',
	'apps/**/sv_*.lua',
}