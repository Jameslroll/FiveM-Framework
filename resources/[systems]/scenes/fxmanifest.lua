fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'@grids/shared/grids.lua',
	'sh_config.lua',
	'sh_main.lua',
}

client_scripts {
	'@misc/misc.lua',
	'@ui/scripts/cl_main.lua',
	'@utils/cl_utils.lua',
	'cl_main.lua',
	'cl_scenes.lua',
	'cl_preview.lua',
	'cl_editor.lua',
	'cl_remover.lua',
}

server_scripts {
	'sv_main.lua',
	'sv_scenes.lua',
	'sv_grids.lua',
}