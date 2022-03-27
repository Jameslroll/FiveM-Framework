export default class Dummy {
	canvasSize = 512;

	frames = {
		path: "./images/dummy",
		start: 0,
		end: 500,
		step: 5,
		duration: 100,
		padding: 4,
	}

	palette = {
		healed: [0, 220, 0],
		injured: [240, 0, 0],
		armored: [80, 80, 250],
	}

	constructor(config, root) {
		this.config = config;
		this.root = root;
		this.info = {};
		
		this.build();

		setInterval(() => {
			requestAnimationFrame(() => this.nextFrame());
		}, this.frames.duration)
	}

	updateInfo(p1, p2) {
		if (typeof p1 === "string") {
			this.info[p1] = p2
		} else {
			this.info = p1
		}
	}

	updateEffect(name, value) {
		const effect = this.effects[name];
		if (!effect) return;
		
		const display = (effect.settings.High || value < 0.99) && (effect.settings.Low || value > 0.01);

		effect.root.style.display = display ? "flex" : "none";

		if (!display) return;

		const color = this.lerp(effect.settings.Invert ? this.palette.healed : this.palette.injured, effect.settings.Invert ? this.palette.injured : this.palette.healed, value);

		effect.fill.style.top = `${(1.0 - value) * 100.0}%`;
		effect.fill.style.background = `rgba(${color[0]}, ${color[1]}, ${color[2]}, 0.8)`;
	}

	build() {
		this.buffer = {};
		this.elements = {};
		this.frame = this.frames.start;
		this.bufferSize = 8;

		// Create parts.
		this.parts = [ "Full" ];
		this.bones = {};

		for (var boneId in this.config.bones) {
			var bone = this.config.bones[boneId];
			if (!bone?.Fallback) {
				this.parts.push(bone.Name);
				this.bones[bone.Name] = bone;
			}
		}

		// Create canvases.
		for (let index = 0; index < this.parts.length; index++) {
			const canvas = document.createElement("canvas");
			canvas.classList.add("body-part");

			canvas.width = this.canvasSize;
			canvas.height = this.canvasSize;
			
			this.buffer[index] = {};
			this.elements[index] = canvas;
			this.root.appendChild(canvas);

			for (let frame = this.frames.start; frame < this.frames.start + this.frames.step * this.bufferSize; frame += this.frames.step) {
				this.insertBuffer(index, frame);
			}
		}

		// Create effects.
		this.effectInfo = {};
		this.effects = {};

		this.effectsRoot = document.createElement("div");
		this.effectsRoot.classList.add("effects");
		this.root.appendChild(this.effectsRoot);

		for (let index = 0; index < this.config.effects.length; index++) {
			// Get effect.
			const effect = this.config.effects[index];

			// Create effect root.
			const element = document.createElement("div");
			element.classList.add("effect");
			element.style.display = "none";

			if (effect.Background) {
				element.classList.add(effect.Background);
			}

			// Create effect fill.
			const fill = document.createElement("div");
			fill.classList.add("fill");

			// Create effect icon.
			const icon = document.createElement("div");
			icon.classList.add("icon");
			icon.style.maskImage = `url('./images/icons/${effect.Name}.png')`;
			icon.style.webkitMaskImage = icon.style.maskImage;
			
			if (effect.Foreground) {
				icon.classList.add(effect.Foreground);
			}
			
			// Append children.
			element.appendChild(fill);
			element.appendChild(icon);
			this.effectsRoot.appendChild(element);

			// Cache effect.
			this.effects[effect.Name] = {
				fill: fill,
				root: element,
				settings: effect,
			}
		}

		// Create pattern.
		this.pattern = new Image();
		this.pattern.src = "./images/misc/pattern.png";

		// Update first frame.
		this.updateFrame();
	}

	focus(fade, duration) {
		const root = this.root;
		if (!root) return;

		if (this.focusTimeout) {
			clearTimeout(this.focusTimeout);
		}

		root.style.animation = `fade-in ${fade}ms normal forwards ease-in-out`;
		
		if (duration != -1) {
			this.focusTimeout = setTimeout(() => {
				root.style.animation = `fade-out ${fade}ms normal forwards ease-in-out`;
			}, duration)
		}
	}

	getFramePath(name, frame) {
		return `${this.frames.path}/${name}/${frame.toString().padStart(this.frames.padding, "0")}.png`;
	}

	nextFrame(frame) {
		if (window.getComputedStyle(this.root).getPropertyValue("opacity") < 0.001) {
			return;
		}

		let nextFrame = (frame ?? this.frame) + this.frames.step;

		if (nextFrame >= this.frames.end) {
			nextFrame = this.frames.start + (nextFrame % this.frames.end);
		}
		
		if (!frame) {
			for (var index in this.buffer) {
				var buffer = this.buffer[index];
				if (!buffer || !buffer[nextFrame]?.complete) {
					// console.log("stop frame", buffer, nextFrame)
					return
				}
			}

			this.frame = nextFrame;
			this.updateFrame();
		}

		return nextFrame;
	}

	updateFrame() {
		for (let index = 0; index < this.parts.length; index++) {
			this.updateBodyPart(index);
		}
	}

	updateBodyPart(index) {
		const frame = this.frame;

		// Get image.
		const img = this.buffer[index][frame];
		if (!img?.complete) return;

		// Get info.
		const name = this.parts[index];
		const isFull = name == "Full";

		// Update canvas.
		const canvas = this.elements[index];
		const ctx = canvas.getContext("2d");

		ctx.clearRect(0, 0, canvas.width, canvas.height);
		ctx.globalCompositeOperation = "source-over";
		
		if (isFull) {
			ctx.drawImage(img, 0, 0, img.width, img.height);
		} else {
			const info = this.info[name];
			var color = this.palette.healed;

			if (info?.armor && info.armor > 0.001) {
				color = this.lerp(color, this.palette.armored, info.armor);
			}

			color = this.lerp(this.palette.injured, color, info?.health ?? 1.0);

			ctx.fillStyle = `rgb(${color[0]}, ${color[1]}, ${color[2]})`;
			ctx.fillRect(0, 0, canvas.width, canvas.height);
			
			ctx.globalCompositeOperation = "destination-in";
			
			ctx.drawImage(img, 0, 0, img.width, img.height);
			
			if (info?.fractured) {
				var pattern = this.pattern;
				ctx.drawImage(pattern, 0, 0, pattern.width, pattern.height);
			}
		}
		
		ctx.restore();
		ctx.save();

		// this.removeBuffer(index, frame);
		this.insertBuffer(index, this.nextFrame(this.frame + this.frames.step * (this.bufferSize - 2)));
	}

	insertBuffer(index, frame) {
		if (this.buffer[index][frame]) return;

		const name = this.parts[index];
		const path = this.getFramePath(name, frame);

		var img = new Image();
		img.src = path;

		this.buffer[index][frame] = img;
	}

	// removeBuffer(index, frame) {
	// 	var img = this.buffer[index][frame];
	// 	img.src = "";
	// 	img = null;

	// 	delete this.buffer[index][frame];
	// }

	lerp(from, to, value) {
		var output = []
		for (let channel = 0; channel < 3; channel++) {
			output[channel] = (to[channel] - from[channel]) * value + from[channel]
		}
		return output;
	}
}