# chat

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```

## Usage

### Registering commands
```Lua
exports.chat:RegisterCommand("name", function(source, args, command)

end, {
	description = "",
	powerLevel = 1,
	parameters = {
		{ name = "", description = "" },
	},
}, group)
```
