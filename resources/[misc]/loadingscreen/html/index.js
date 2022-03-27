let slides = [
	"1.png",
	"2.png",
	"3.png",
	"4.png",
	"5.png",
	"6.png",
	"7.png",
	"8.png",
	"9.png",
	"10.png",
	"11.png",
	"12.png",
	"13.png",
	"14.png",
	"15.png",
	"16.png",
	"17.png",
	"18.png",
	"19.png",
	"20.png",
	"21.png",
	"22.png",
	"23.png",
	"24.png",
	"25.png",
	"26.png",
	"27.png",
	"28.png",
	"29.png",
	"30.png",
	"31.png",
	"32.png",
	"33.png",
	"34.png",
	"35.png",
	"36.png",
	"37.png",
	"38.png",
	"39.png",
	"40.png",
	"41.png",
	"42.png",
	"43.png",
	"44.png",
	"45.png",
	"46.png",
	"47.png",
	"48.png",
	"49.png",
	"50.png",
	"51.png",
	"52.png",
	"53.png",
	"54.png",
	"55.png",
	"56.png",
	"57.png",
	"58.png",
	"59.png",
	"60.png",
	"61.png",
	"62.png",
];

let portraits = [];
let active = {};

class Portrait {
	scroll = 0.0;

	constructor() {
		this.root = document.querySelector(".portraits");
	}
	spawn(time) {
		let slide = this.getNextSlide();
		let element = document.createElement("img");
		let parallax = Math.random();

		element.classList.add("portrait");
		element.src = `assets/slices/${slide}`;
		element.style.height = `${20.0 + parallax * 40.0}vmin`;
		element.style.bottom = `-${Math.pow(parallax, 2.0) * 20.0}vmin`;
		element.style.zIndex = Math.floor(parallax * 1000.0);
		element.alt = "";
		
		this.root.appendChild(element);
		this.element = element;
		this.slide = slide;
		this.parallax = parallax;
		this.update(time ?? 0.0);
		
		active[slide] = true;
		portraits.push(this);
	}
	destroy() {
		this.element.remove();
		active[this.slide] = undefined;

		var index = portraits.indexOf(this);
		if (index != -1) {
			portraits.splice(index, 1);
		}

		var portrait = new Portrait();
		portrait.spawn();
	}
	async update(delta) {
		var element = this.element;
		var rect = element.getBoundingClientRect();

		element.style.left = `${(1.0 - this.scroll) * 100.0}%`;

		this.scroll += delta * (this.parallax * 0.5 + 0.5);

		if (this.scroll > 1.0 + (rect.width / window.screen.width)) {
			this.destroy();
		}
	}
	getNextSlide() {
		var slide = undefined;
		while (!slide || active[slide]) {
			slide = slides[Math.floor(Math.random() * slides.length)];
		}

		return slide;
	}
}

class Background {
	fromX = 0.0;
	fromY = 0.0;
	offsetX = 0.0;
	offsetY = 0.0;
	targetX = 0.0;
	targetY = 0.0;
	targetTime = 0;
	scale = 2.0;
	duration = 1000.0;

	constructor() {
		this.background = document.querySelector(".background");
	}
	update() {
		var time = new Date().getTime();
		
		if (time >= this.targetTime) {
			this.duration = lerp(1000, 2000, Math.random()^1.5);
			this.targetTime = time + Math.floor(this.duration);

			this.fromX = this.offsetX;
			this.fromY = this.offsetY;

			this.targetX = Math.random();
			this.targetY = Math.random();
		}

		var value = Math.sin(1.0 - (this.targetTime - time) / this.duration);

		this.offsetX = Math.min(Math.max(lerp(this.fromX, this.targetX, value), 0.0), 1.0);
		this.offsetY = Math.min(Math.max(lerp(this.fromY, this.targetY, value), 0.0), 1.0);

		this.background.style.transform = `translate(${(this.offsetX - 0.5) * this.scale}%, ${(this.offsetY - 0.5) * this.scale}%) scale(${1.1 + this.scale * 0.01})`;
	}
}

document.addEventListener("DOMContentLoaded", function() {
	let background = new Background();
	let lastUpdate = undefined;

	setInterval(() => {
		var time = new Date().getTime();
		var delta = (time - (lastUpdate ?? time)) / 1000.0;

		background.update();

		for (var portrait of portraits) {
			portrait.update(delta * 0.04);
		}

		lastUpdate = time;
	}, 0);

	var limit = 16;
	for (let i = 0; i < limit; i++) {
		var portrait = new Portrait();
		portrait.spawn(i / (limit - 3));
	}
});

function lerp(a, b, u) {
	return (1 - u) * a + u * b;
}