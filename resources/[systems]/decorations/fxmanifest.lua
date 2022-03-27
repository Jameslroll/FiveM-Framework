fx_version 'adamant'
game 'gta5'

data_file 'DLC_ITYP_REQUEST' 'stream/decorations.ytyp'

dependencies {
	'inventory',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'shared/config.lua',
	'shared/main.lua',
	'decorations/*.lua',
}

client_scripts {
	'@utils/client/vectors.lua',
	'@utils/client/misc.lua',
	'@camera/cl_camera.lua',
	'client/main.lua',
	'client/decoration.lua',
	'client/stations.lua',
	'client/queue.lua',
	'client/editor.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'server/config.lua',
	'server/main.lua',
	'server/decoration.lua',
	'server/stations.lua',
	'server/grids.lua',
}