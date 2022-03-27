fx_version 'adamant'
game 'gta5'

files {
	'icons/*.png',
}

shared_script {
	'@grids/shared/grids.lua',
	'@utils/shared/math.lua',
	'@utils/shared/color.lua',
	'config/*.lua',
	'sh_main.lua',
	'modules/**/sh_*.lua',
}

client_scripts {
	'@camera/cl_camera.lua',
	'@utils/client/entities.lua',
	'@utils/client/misc.lua',
	'@utils/client/vehicles.lua',
	'@utils/client/vectors.lua',
	'@ui/scripts/cl_main.lua',
	'cl_main.lua',
	'cl_commands.lua',
	'modules/**/cl_*.lua',
	'modding/cl_modding.lua',
	'modding/cl_mods.lua',
	'modding/cl_paint.lua',
}

server_scripts {
	'@utils/server/random.lua',
	'@utils/server/players.lua',
	'sv_main.lua',
	'sv_vehicle.lua',
	'sv_commands.lua',
	'modules/**/sv_*.lua',
}