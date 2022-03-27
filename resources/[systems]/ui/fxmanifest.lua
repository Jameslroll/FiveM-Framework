fx_version 'cerulean'
game 'gta5'

dependencies {
	'yarn',
	'webpack',
}

ui_page 'dist/index.html'

files {
	'dist/css/*.css',
	'dist/js/*.js',
	'dist/img/*.png',
	'dist/fonts/*.woff',
	'dist/fonts/*.woff2',
	'dist/index.html',
	'scripts/cl_*.lua',
}

shared_scripts {
	'@utils/shared/color.lua',
	'@utils/shared/math.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'@utils/server/date.lua',
	'@utils/server/players.lua',
	'@utils/server/random.lua',
}

client_scripts {
	'@utils/client/blips.lua',
	'@utils/client/entities.lua',
	'@utils/client/loading.lua',
	'@utils/client/misc.lua',
	'@utils/client/vectors.lua',
	'@utils/client/vehicles.lua',
	'scripts/cl_config.lua',
	'scripts/cl_main.lua',
	'scripts/cl_commands.lua',
	'scripts/cl_events.lua',
}