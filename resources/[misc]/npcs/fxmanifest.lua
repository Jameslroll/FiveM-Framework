fx_version 'cerulean'
game 'gta5'

files {
	'client/*.lua',
	'shared/*.lua',
}

shared_scripts {
	'@grids/shared/grids.lua',
	-- 'shared.lua',
	-- 'shared/config.lua',
	-- 'shared/main.lua',
	-- 'shared/npc.lua',
	-- 'npcs/test.lua', -- test, should glob
}

client_scripts {
	'@ui/scripts/cl_main.lua',
	'client.lua',
	-- 'client/main.lua',
	-- 'client/npc.lua',
}

server_scripts {
	'server.lua',
	-- 'server/main.lua',
	-- 'server/npc.lua',
}