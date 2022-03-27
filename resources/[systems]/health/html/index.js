import Dummy from "./modules/dummy.js"
import Treatment from "./modules/treatment.js"

let dummies = {};
let funcs = {};
let intervals = {};
let config = {};
let debug = false;
let treatment = undefined;

document.addEventListener("DOMContentLoaded", function() {
	if (debug) {
		const config = {
			effects: [],
			bones: [
				{ Name: "SKEL_Head" },
				{ Name: "SKEL_L_Calf" },
				{ Name: "SKEL_L_Clavicle" },
				{ Name: "SKEL_L_Foot" },
				{ Name: "SKEL_L_Forearm" },
				{ Name: "SKEL_L_Hand" },
				{ Name: "SKEL_L_Thigh" },
				{ Name: "SKEL_L_UpperArm" },
				{ Name: "SKEL_Pelvis" },
				{ Name: "SKEL_R_Calf" },
				{ Name: "SKEL_R_Clavicle" },
				{ Name: "SKEL_R_Foot" },
				{ Name: "SKEL_R_Forearm" },
				{ Name: "SKEL_R_Hand" },
				{ Name: "SKEL_R_Thigh" },
				{ Name: "SKEL_R_UpperArm" },
				{ Name: "SKEL_Spine2" },
				{ Name: "SKEL_Spine3" },
			]
		}
		
		window.postMessage({
			invoke: {
				method: "loadConfig",
				args: [ config ]
			}
		})

		window.postMessage({
			invoke: {
				method: "setTreatment",
				args: [
					[
						{ label: "Bandage" },
						{ label: "Insert gauze" },
						{ label: "" },
						{ label: "" },
					]
				]
			}
		})
	} else {
		post("init");
	}
});

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.invoke) {
		if (data.invoke.target) {
			var dummy = dummies[data.invoke.target ?? false];
			if (!dummy) {
				dummy = createDummy(data.invoke.target);
				dummy.root.classList.add("left");

				return
			}
	
			if (data.invoke.method) {
				var func = dummy[data.invoke.method];
				if (typeof func === "function") {
					dummy[data.invoke.method](...(data.invoke.args ?? []));
				}
			}
		} else {
			var func = funcs[data.invoke.method];
			if (func) {
				func(...(data.invoke.args ?? []));
			}
		}
	}
});

funcs["setOverlay"] = function(id, value) {
	let element = document.querySelector(`.overlays #${id.toLowerCase()}`);
	if (!element) return;

	var interval = intervals[id];
	if (interval) {
		clearInterval(interval);
	}

	intervals[id] = setInterval(() => {
		var opacity = parseFloat(element.style.opacity);
		if (isNaN(opacity)) opacity = 0.0;

		var newOpacity = lerp(opacity, value, 0.02);
		
		if (Math.abs(opacity - newOpacity) < 0.001) {
			clearInterval(intervals[id])
			newOpacity = value;
		}

		element.style.opacity = newOpacity;
	}, 20);
}

funcs["loadConfig"] = function(data) {
	console.log("load config");
	
	config = data;

	var dummy = createDummy("main");
	dummy.root.classList.add("right");

	if (debug) {
		dummy.info = {
			"SKEL_Head": {
				health: 0.2,
				injuries: {
					"9mm GSW": {
						amount: 2,
					},
				},
			},
			"SKEL_L_Clavicle": {
				armor: 1.0,
			},
			"SKEL_R_Clavicle": {
				armor: 1.0,
			},
			"SKEL_Spine3": {
				armor: 1.0,
			},
			"SKEL_Spine2": {
				armor: 1.0,
			},
			"Other": {
				
			},
		}
	}
}

funcs["setTreatment"] = function(x, y, options) {
	if (treatment) {
		treatment.destroy();
	}

	if (options) {
		treatment = new Treatment(x, y, options);
	}
}

funcs["setHtml"] = function(selector, html) {
	var element = document.querySelector(selector);
	if (element) {
		element.innerHTML = html;
	}
}

function createDummy(id) {
	// Create root.
	const root = document.createElement("div");
	root.classList.add("dummy");
	root.id = id;

	document.body.appendChild(root);

	// Create dummy.
	const dummy = new Dummy(config, root);
	dummies[id] = dummy;

	return dummy
}

function lerp(a, b, t) {
	t = t < 0 ? 0 : t;
	t = t > 1 ? 1 : t;
	return a + (b - a) * t;
};

function post(type, data) {
	try {
		fetch(`https://${GetParentResourceName()}/${type}`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json; charset=UTF-8',
			},
			body: JSON.stringify(data)
		})
	} catch {}
}