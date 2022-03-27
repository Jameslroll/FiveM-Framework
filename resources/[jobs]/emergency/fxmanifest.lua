fx_version 'cerulean'
game 'gta5'

dependencies {
	'jobs',
	'trackers',
}

shared_script {
	'@jobs/flags.lua',
	'sh_job.lua',
}

client_scripts {
}

server_scripts {
	'sv_trackers.lua',
}