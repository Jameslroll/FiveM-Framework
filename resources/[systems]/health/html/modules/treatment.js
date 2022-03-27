export default class Treatment {
	radius = 20.0
	padding = 8.0

	constructor(x, y, options) {
		let root = document.createElement("div");
		root.style.top = `${Math.min(Math.max(y * 100.0, this.radius + this.padding), 100.0 - this.radius - this.padding)}%`;
		root.style.left = `${Math.min(Math.max(x * 100.0, this.radius + this.padding), 100.0 - this.radius - this.padding)}%`;
		root.classList.add("treatment");
		
		document.body.appendChild(root);
		
		this.root = root;
		this.updateOptions(options);
	}

	updateOptions(options) {
		this.options = options;

		const step = 1.0 / options.length * 2.0 * Math.PI;

		for (let index in options) {
			const option = options[index];
			const radians = index * step + Math.PI;
			const x = Math.cos(radians);
			const y = Math.sin(radians);

			let element = document.createElement("div");
			element.classList.add("option");
			element.style.top = `${x * this.radius}vmin`;
			element.style.left = `${y * this.radius}vmin`;

			let icon = document.createElement("img");
			icon.classList.add("icon");
			icon.src = option.icon ?? "./images/icons/Health.png";

			let label = document.createElement("div");
			label.classList.add("label");
			label.innerHTML = option.label ?? "???";

			element.appendChild(icon);
			element.appendChild(label);
			this.root.appendChild(element);
		}
	}

	destroy() {
		if (this.root) {
			this.root.remove();
		}
	}
}