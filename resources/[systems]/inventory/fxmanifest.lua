fx_version 'cerulean'
game 'gta5'

ui_page 'dist/index.html'

files {
	'dist/css/*.css',
	'dist/js/*.js',
	'dist/img/*.png',
	'dist/fonts/*.ttf',
	'dist/index.html',
	'icons/*.png',
}

dependencies {
	'yarn',
	'webpack',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'scripts/shared/config.lua',
	'scripts/shared/inventory.lua',
	'scripts/shared/containers.lua',
	'scripts/shared/slots.lua',
	'scripts/shared/items.lua',
	'scripts/shared/misc.lua',
	'scripts/shared/money.lua',
}

client_scripts {
	'scripts/client/menu.lua',
	'scripts/client/inventory.lua',
	'scripts/client/containers.lua',
	'scripts/client/slots.lua',
	'scripts/client/players.lua',
	'scripts/client/items.lua',
	'scripts/client/binds.lua',
	'scripts/client/drops.lua',
	'scripts/client/nested.lua',
	'scripts/client/packs.lua',
	'scripts/client/crafting.lua',
	'scripts/client/money.lua',
	'items/*.lua',
	'recipes/*.lua',
	'scripts/client/threads.lua',
	'scripts/client/commands.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'scripts/server/config.lua',
	'scripts/server/inventory.lua',
	'scripts/server/items.lua',
	'scripts/server/containers.lua',
	'scripts/server/slots.lua',
	'scripts/server/decay.lua',
	'scripts/server/players.lua',
	'scripts/server/grids.lua',
	'scripts/server/drops.lua',
	'scripts/server/nested.lua',
	'scripts/server/packs.lua',
	'scripts/server/money.lua',
	'scripts/server/crafting.lua',
	'items/*.lua',
	'recipes/*.lua',
	'scripts/server/commands.lua',
}