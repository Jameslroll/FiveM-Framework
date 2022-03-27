fx_version 'cerulean'
game 'gta5'

dependencies {
	'entities',
}

shared_script {
	'flags.lua',
	'sh_config.lua',
	'sh_jobs.lua',
	'jobs/*.lua',
}

client_scripts {
	'cl_jobs.lua',
}

server_scripts {
	'@utils/server/players.lua',
	'@utils/server/database.lua',
	'sv_jobs.lua',
}