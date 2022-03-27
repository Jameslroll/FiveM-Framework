# User Interface

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

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).

## Components

### All
- **type** / *string* / The component's type to use. Supports HTML, Quasar, or other custom components.
- **style** / *array* / Binds the CSS objects to the component's style.
- **components** / *list* / Nested components.
- **class** / *string or list* / Class or classes to bind to the component.
- **binds** / *array* / General binding objects to bind to the component.
- **model** / *string* / Creates a binding from the component to the window's model specified.

### Windows
- **title** / *string* / The text displayed in the header of a window. The header is disabled when undefined.
- **defaults** / *array* / Applies defaults to the model.

```Lua
{
	type = "window",
	title = "Window Title",
	style = {
		["width"] = "50vmin",
		["height"] = "auto",
		["top"] = "50%",
		["left"] = "50%",
		["transform"] = "translate(-50%, -50%)",
	},
	components = [

	],
}
```