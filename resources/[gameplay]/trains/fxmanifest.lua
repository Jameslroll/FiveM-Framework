fx_version 'adamant'
game 'gta5'

shared_script {
	-- 'sh_config.lua',
	'@grids/shared/grids.lua',
	'sh_config.lua',
	'sh_tracks.lua',
}

client_scripts {
	'cl_trains.lua',
}

server_scripts {
	'@utils/server/random.lua',
	'sv_trains.lua',
}