fx_version 'adamant'
game 'gta5'

dependencies {
	'GHMattiMySQL',
}

shared_script {
	'config/*.lua',
}

client_scripts {
	'cl_garages.lua',
	'cl_parking.lua',
}

server_scripts {
	'sv_garages.lua',
}