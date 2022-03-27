const fs = require("fs").promises
const fileCount = 12
const path = `${GetResourcePath(GetCurrentResourceName())}`

async function generate() {
	let output = "Tracks = {\n"

	for (let i = 1; i <= fileCount; i++) {
		const data = await fs.readFile(`${path}/data/trains${i}.dat`, "utf8")
		const lines = data.split(/\n+/g)
		
		output += `\t[${i}] = {\n`
	
		lines.forEach(line => {
			let [x, y, z, w] = line.split(/\s+/)
	
			if (x != undefined && y != undefined && z != undefined && w != undefined) {
				output += `\t\tvector4(${x}, ${y}, ${z}, ${w}),\n`
			}
		})
	
		output += "\t},\n"
	}
	
	output += "}"
	
	await fs.writeFile(`${path}/output.lua`, output)

	console.log("Done!")
}

generate()