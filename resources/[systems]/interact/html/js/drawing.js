let Objects = {};
let Right = new THREE.Vector3(1, 0, 0);

const Config = {
	MaxPlaneSize: 2.0,
	MaxCanvasSize: 2048,
};

document.addEventListener("DOMContentLoaded", function() {
	// Create the scene.
	Scene = new THREE.Scene();

	// Create the camera.
	Camera = new THREE.PerspectiveCamera(60.0, window.innerWidth / window.innerHeight, 0.1, 1000);
	Camera.up.set(0, 0, 1);

	// Create the label renderer.
	Renderer = new THREE.CSS2DRenderer();
	Renderer.domElement.style.position = "absolute";
	Renderer.domElement.style.top = 0;
	Renderer.setSize(window.innerWidth, window.innerHeight);

	// Create the other renderer.
	Renderer2 = new THREE.WebGLRenderer({ alpha: true });
	Renderer2.setSize(window.innerWidth, window.innerHeight)

	// Create the lighting.
	AmbientLight = new THREE.AmbientLight(0xFFFFFF);
	Scene.add(AmbientLight);

	// Append the elements.
	document.body.appendChild(Renderer.domElement);
	document.body.appendChild(Renderer2.domElement);

	// Animate.
	animate();
});

window.addEventListener("message", (event) => {
	var data = event.data;

	if (data.camera) {
		updateCamera(data.camera);
	}
});

window.addEventListener("resize", () => {
	Camera.aspect = window.innerWidth / window.innerHeight;

	Renderer.setSize(window.innerWidth, window.innerHeight);
	Renderer2.setSize(window.innerWidth, window.innerHeight);
});

/* Rendering */
function animate() {
	if (!Renderer) {
		return;
	}

	requestAnimationFrame(animate);

	Renderer.render(Scene, Camera);
	Renderer2.render(Scene, Camera);
}

/* Camera */
function updateCamera(data) {
	Camera.fov = data.fov;
	Camera.position.set(data.coords.x, data.coords.y, data.coords.z);
	Camera.lookAt(data.target.x, data.target.y, data.target.z);

	Camera.updateProjectionMatrix();

	for (var id in Objects) {
		var object = Objects[id]
		if (object?.maxDistance) {
			var dist = Camera.position.distanceTo(object.position) / object.maxDistance;
			var element = object.domElement;
			element.style.transform = `scale(${1.0 - Math.min(Math.max(dist, 0.0), 1.0)})`;
		}
	}
}

/* Text */
function addText(data) {
	const domElement = document.createElement("div");
	domElement.style.position = "absolute";
	
	const innerElement = document.createElement("div");
	innerElement.innerHTML = data.text;
	
	domElement.appendChild(innerElement);
	
	if (data.transparent) {
		innerElement.style.background = "transparent";
	}

	if (data.fit) {
		innerElement.style.width = "100%";
		innerElement.style.height = "100%";
	}

	if (data.style) {
		for (var style in data.style) {
			innerElement.style[style] = data.style[style];
		}
	}

	if (data.useCanvas) {
		data.width = Math.min(Math.max(data.width, 0.0), 1.0) ?? 1.0;
		data.height = Math.min(Math.max(data.height, 0.0), 1.0) ?? 1.0;

		const pixelWidth = Math.floor(data.width ** 0.5 * Config.MaxCanvasSize);
		const pixelHeight = Math.floor(data.height ** 0.5 * Config.MaxCanvasSize);

		const planeWidth = data.width * Config.MaxPlaneSize;
		const planeHeight = data.height * Config.MaxPlaneSize;

		domElement.style.width = pixelWidth + "px";
		domElement.style.height = pixelHeight + "px";
		domElement.style.top = "0px";
		domElement.style.top = window.innerHeight + "px";

		innerElement.className = "canvas";

		document.body.appendChild(domElement);

		html2canvas(domElement, {
			width: pixelWidth,
			height: pixelHeight,
			backgroundColor: null,
			useCORS: true,
			logging: false,
		}).then(function(canvas) {
			domElement.remove();

			const texture = new THREE.Texture(canvas);
			texture.needsUpdate = true;
	
			const geometry = new THREE.PlaneGeometry(planeWidth, planeHeight);
			const material = new THREE.MeshPhongMaterial({ side: THREE.FrontSide, map: texture, specularMap: texture, alphaTest: 0.5 });
			const plane = new THREE.Mesh(geometry, material);

			if (data.coords) {
				plane.position.set(data.coords.x, data.coords.y, data.coords.z);
			}

			if (data.rotation) {
				setEulerAngles(plane, data.rotation);
			}
	
			Scene.add(plane);

			Objects[data.id] = plane;
		})

		return
	}

	innerElement.className = "label";

	const label = new THREE.CSS2DObject(domElement);
	label.domElement = innerElement;
	label.maxDistance = data.distance;

	if (data.coords) {
		label.position.set(data.coords.x, data.coords.y, data.coords.z);
	}

	Scene.add(label);

	Objects[data.id] = label;
}

function removeText(data) {
	var label = Objects[data.id];
	if (!label) {
		return;
	}

	Scene.remove(label);

	delete Objects[data.id];
}

function updateText(data) {
	var label = Objects[data.id];
	if (!label) {
		return;
	}

	if (data.coords) {
		label.position.set(data.coords.x, data.coords.y, data.coords.z);
	}

	if (data.rotation) {
		setEulerAngles(label, data.rotation);
	}

	if (data.text) {
		label.domElement.innerHTML = data.text;
	}

	if (data.visible !== undefined) {
		label.visible = data.visible;
	}
}

function setEulerAngles(object, rotation) {
	var deg2Rad = Math.PI / 180.0;

	object.setRotationFromEuler(new THREE.Euler(rotation.x * deg2Rad, rotation.y * deg2Rad, rotation.z * deg2Rad, "ZYX"));
}