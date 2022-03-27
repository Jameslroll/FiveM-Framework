Container = document.querySelector("#notifications");
Debug = false;
Display = false;
Instances = [];

$(document).ready(function() {
	if (Debug) {
		addNotification({
			alert: "10-47",
			text: "Injured",
			location: "Paleto Blvd, Paleto Bay",
			vehicle: "696999: Black Colored Car"
		});
	
		var t1 = addNotification({
			status: "urgent",
			alert: "10-13",
			text: "Officer in distress",
			location: "New Empire Way, Los Santos International Airport",
		});

		var t1 = addNotification({
			alert: "10-52",
			text: "Ambulance needed",
			location: "Vespucci Blvd & Elgin Ave, Pillbox Hill",
			vehicle: "45EUL810: Metallic White Police Cruiser",
			extra: "John Doe - 111222333",
		});
	
		for (let i = 0; i < 3; i++) {
			setTimeout(() => {
				var instance = addNotification({
					alert: "10-69",
					text: "Something " + i,
					location: "Occupation Ave, Alta",
				});
		
				for	(i2 = 0; i2 < Math.random() * 6; i2++) {
					instance.units.add(Math.floor(Math.random() * 100 + 400));
				}
			}, i * 500)
		}

		window.postMessage({
			// display: true,
			codes: {
				["10-0"]: {
					Message: "Caution",
					CanCall: true,
					Type: "minor",
				},
				["10-1"]: {
					Message: "Reception poor",
					CanCall: false,
					Type: "minor",
				},
				["10-2"]: {
					Message: "Reception good",
					CanCall: false,
					Type: "minor",
				},
				["10-3"]: {
					Message: "Stop transmitting",
					CanCall: false,
					Type: "minor",
				},
			},
		});
	}

	setInterval(() => {
		const time = new Date().getTime() / 1000.0;

		for (let instance of Instances) {
			const age = time - instance.time;
			instance.querySelector("#time").innerHTML = formatTime(age);

			if (age > 10.0) {
				if (!Display) {
					instance.classList.remove("slide-in");
					instance.classList.add("slide-out");
				}

				setTimeout(() => {
					if (!Display) {
						instance.style.display = "none";
					}
					
					instance.timeOut = true;
				}, 500);
			}
		}
	}, 1000);
});

$("#clear").click(() => {
	for (var instance of Instances) {
		if (!instance.removed) {
			instance.hide(true);
		}
	}
});

$("#restore").click(() => {
	for (var instance of Instances) {
		if (instance.removed) {
			instance.show();
		}
	}
});

$("#close").click(() => {
	$.post("http://dispatch/toggleMenu")
});

window.addEventListener("message", (event) => {
	var data = event.data;
	if (!data) return;

	if (data.display != undefined) {
		Display = data.display;
		document.querySelector("#options").style.visibility = Display ? "visible" : "hidden";

		for (var instance of Instances) {
			if (!Display && instance.timeOut) {
				instance.style.display = "none";
			} else if (Display && !instance.removed) {
				instance.classList.remove("slide-in");
				instance.classList.remove("slide-out");
				instance.style.display = "block";
			}
		}
	}

	if (data.codes != undefined) {
		setupCodes(data.codes);
	}

	if (data.report != undefined) {
		addNotification(data.report);
	}

	if (data.reports != undefined) {
		for (var instance of Instances) {
			instance.remove();
		}

		Instances = [];

		for (var report of data.reports) {
			var instance = addNotification(report);
			instance.classList.remove("slide-in");
			instance.style.display = "none";
			instance.timeOut = true;
		}
	}
});

function addNotification(data) {
	if (Instances.length > 100) {
		var oldestInstance = Instances[0];
		if (oldestInstance != undefined) {
			oldestInstance.remove();
		}

		Instances.splice(0, 1);
	}

	// Create the instance.
	let instance = document.createElement("div");
	instance.classList.add("notification");
	instance.classList.add("slide-in");
	instance.classList.add(data.status || "normal");
	instance.style.paddingRight = "16px";
	
	instance.hide = (remove) => {
		instance.classList.remove("slide-in");
		instance.classList.add("slide-out");
		instance.removed = remove;

		setTimeout(() => {
			instance.style.display = "none";
		}, 500);
	};
	
	instance.show = () => {
		instance.classList.remove("slide-out");
		instance.classList.add("slide-in");
		instance.style.display = "block";
		instance.removed = false;
	};

	if (data.priority === false) {
		instance.style.opacity = 0.5;
		instance.priority = false;
	}

	// Top right: remove button.
	let removeButton = createElement("button", instance);
	removeButton.classList.add("remove");
	removeButton.classList.add("tag");
	removeButton.classList.add("red");
	removeButton.innerHTML = "X";

	removeButton.onclick = () => {
		instance.hide(true);
	};

	// First line: basic info.
	let alertTag = createTag(instance, data.alert, "red");
	let textSpan = createText(instance, data.text || "");
	textSpan.classList.add("bold");

	// Time stamp.
	createElement("br", instance);
	
	let timeDiv = createElement("div", instance);
	let clockImg = createImage(timeDiv, "clock.png");
	let timeSpan = createText(timeDiv, formatTime(data.time || 0));
	timeSpan.id = "time";

	if (data.age) {
		var time = (new Date().getTime() / 1000.0) - data.age;
		instance.time = time;
	} else {
		instance.time = new Date().getTime() / 1000.0;
	}

	// Phone number.
	if (data.phone) {
		createElement("br", instance);

		let phoneDiv = createElement("div", instance);
		let phoneImg = createImage(phoneDiv, "phone.png");
		let phoneSpan = createText(phoneDiv, `[${data.source || '?'}] ${data.phone.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3')}`);
	}

	// Vehicles.
	if (data.vehicle) {
		createElement("br", instance);
		
		let vehicleDiv = createElement("div", instance);
		let vehicleImg = createImage(vehicleDiv, "vehicle.png");
		let vehicleSpan = createText(vehicleDiv, data.vehicle);
	}

	// Extra.
	if (data.extra) {
		createElement("br", instance);
		
		let extraDiv = createElement("div", instance);
		let extraImg = createImage(extraDiv, "extra.png");
		let extraSpan = createText(extraDiv, data.extra);
	}

	// Location.
	createElement("br", instance);
	
	let locationDiv = createElement("div", instance);
	locationDiv.style.width = "100%";

	let pinImg = createImage(locationDiv, "pin.png");
	let locationSpan = createElement("span", locationDiv);
	let locationText = createText(locationSpan, data.location || "");
	locationText.style.marginRight = "6px";

	// Background events.
	locationDiv.onmouseenter = (e) => {
		pinImg.classList.add("pin-hover");
		instance.plusUnit = createTag(locationSpan, "+1", "red");
		instance.plusUnit.style.opacity = 0.5;
		instance.plusUnit.style.marginTop = "4px";
	};
	
	locationDiv.onmouseleave = (e) => {
		pinImg.classList.remove("pin-hover");
		instance.plusUnit.remove();
	};

	locationDiv.onclick = (e) => {
		$.post("http://dispatch/addUnit", JSON.stringify({
			id: data.identifier,
		}))
	}

	// Units.
	instance.units = {
		tags: {},
		add: callsign => {
			var tag = createTag(locationSpan, callsign, "black");
			tag.style.marginTop = "4px";
			instance.units.tags[callsign] = tag;
		},
		remove: callsign => {
			var tag = instance.units.tags[callsign];
			if (tag) {
				tag.remove();
				delete instance.units.tags[callsign];
			}
		},
	};

	// Other.
	instance.onmouseenter = (e) => {
		removeButton.style.display = "inline-block";
		instance.style.opacity = 1.0;
	};

	instance.onmouseleave = (e) => {
		removeButton.style.display = "none";

		if (instance.priority === false) {
			instance.style.opacity = 0.5;
		}
	};

	// Cache instance.
	if (Container.childNodes[0]) {
		Container.insertBefore(instance, Container.childNodes[0]);
	} else {
		Container.appendChild(instance);
	}

	Instances.push(instance);

	return instance;
}

function setupCodes(codes) {
	var root = document.querySelector("#codes");
	root.innerHTML = "";
	root.style.display = codes ? "flex" : "none";

	if (!codes) {
		return;
	}

	var items = [];

	for (var code in codes) {
		var settings = codes[code];
		var span = document.createElement("span");
		span.textContent = `${code} - ${settings.Message}`;
		span.code = parseInt(code.replace(/\D/g, "")) || 0;
		span.style.display = "flex";

		items.push(span);
	}

	items.sort(function(a, b) {
		return a.code == b.code ? 0 : (a.code > b.code ? 1 : -1);
	});

	for (i = 0; i < items.length; ++i) {
		root.appendChild(items[i]);
	}
}

function formatTime(seconds) {
	if (seconds < 3) {
		return "Just now";
	} else if (seconds < 60) {
		return `${Math.ceil(seconds)} seconds ago`;
	} else {
		return `${Math.floor(seconds / 60.0)} minute${seconds > 120 ? 's' : ''} ago`;
	}
}

function createTag(instance, text, type) {
	var span = createText(instance, text);
	span.classList.add("tag");
	span.classList.add(type || "blue");

	return span;
}

function createText(instance, text) {
	var span = createElement("span", instance);
	span.innerHTML = text;

	return span;
}

function createImage(instance, src) {
	var img = createElement("div", instance);
	img.style.setProperty("-mask-image", `url(assets/images/${src})`);
	img.style.setProperty("-webkit-mask-image", `url(assets/images/${src})`);
	img.classList.add("img");
	
	return img;
}

function createElement(tagName, parent) {
	var element = document.createElement(tagName)
	parent?.appendChild(element);

	return element;
}