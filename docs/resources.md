## Manifest
- Create a file named `fxmanifest.lua`.
- Remove unused sections.
```Lua
fx_version 'cerulean'
game 'gta5'

ui_page ''

files {

}

dependencies {
	
}

shared_scripts {
	'sh_config.lua',
	'sh_resourceName.lua',
}

client_scripts {
	'cl_resourceName.lua',
}

server_scripts {
	'sv_resourceName.lua',
}
```