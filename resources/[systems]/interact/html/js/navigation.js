const Deg2Rad = Math.PI / 180;
const Rad2Deg = 180 / Math.PI;

var Options = {};
var Containers = [];
var Active = undefined;
var Root = undefined;
var LastX = 0;
var LastY = 0;

const CenterRadius = 0.06;
const CenterOffset = 15;
const SubOffset = 10;

document.addEventListener("DOMContentLoaded", function() {
	Root = document.querySelector("#navigation");

	// for (let i = 1; i <= 10; i++) {
	// 	addOption({
	// 		id: "option-" + i,
	// 		text: "Option " + i,
	// 		icon: "person",
	// 		sub: [
	// 			{
	// 				text: "Sub-option 1",
	// 				icon: "info",
	// 			},
	// 			{
	// 				text: "Sub-option 2",
	// 				icon: "info",
	// 			},
	// 			{
	// 				text: "Sub-option 3",
	// 				icon: "info",
	// 			},
	// 			{
	// 				text: "Sub-option 4",
	// 				icon: "info",
	// 			},
	// 		],
	// 	});
	// }

	// removeOption("option-2");
});

document.addEventListener("mousedown", function(e) {
	if (Active) {
		Active.onclick();
	}
});

document.addEventListener("mousemove", function(e) {
	var x = e.clientX;
	var y = e.clientY;
	var vMin = Math.min(screen.width, screen.height);

	if (Math.abs(LastX - x) < 10 && Math.abs(LastY - y) < 10) return;

	var nearest = undefined;
	var nearestDist = 0.0;
	
	var centerDist = getDistance(screen.width / 2, screen.height / 2, x, y);
	if (centerDist > vMin * CenterRadius) {
		for (var container of Containers) {
			if (!container) continue;
	
			for (var child of container.childNodes) {
				// Get child size.
				var childRect = child.getBoundingClientRect();
				var childX = childRect.left + childRect.width / 2;
				var childY = childRect.top + childRect.height / 2;
	
				// Get dist to child.
				var dist = getDistance(childX, childY, x, y);
	
				// Update nearest.
				if (!nearest || dist < nearestDist) {
					nearest = child;
					nearestDist = dist;
				}
			}
		}
	}

	if (nearest != Active) {
		if (Active) {
			Active.classList.remove("active");
		}
	
		if (nearest) {
			nearest.classList.add("active");
			nearest.onselect();
		} else {
			for (var i = 1; i < Containers.length; i++) {
				removeContainer(i);
			}
		}

		Active = nearest;
	}

	LastX = x;
	LastY = y;
});

document.querySelector("#close-navigation").addEventListener("click", (e) => {
	Root.style.display = "none";
	post("closeNavigation");
});

function toggleNavigation(data) {
	Root.style.display = data?.value ? "block" : "none";
}

function setOptions(options) {
	Options[option.id] = {};

	for (var option of options) {
		createElement(0, option);
	}

	orderElements(0);
}

function addOption(option) {
	removeOption(option.id, true);

	Options[option.id] = createElement(0, option);

	orderElements(0);
}

function removeOption(id, noOrder) {
	var element = Options[id];

	if (element) {
		element.remove();
		
		for (var i = 1; i < Containers.length; i++) {
			removeContainer(i);
		}

		delete Options[id];

		if (!noOrder) {
			orderElements(0);
		}
	}
}

function getContainer(id) {
	var container = Containers[id];

	if (container == undefined) {
		container = document.createElement("div");
		container.classList.add("container");
		Root.appendChild(container);

		Containers[id] = container;
	}

	return container;
}

function removeContainer(id) {
	var container = Containers[id];
	if (container == undefined) return

	container.remove();

	delete Containers[id];
}

function createElement(index, option) {
	var container = getContainer(index);

	var element = document.createElement("div");
	element.classList.add("option");
	
	var text = document.createElement("span");
	text.innerText = option.text;

	var icon = document.createElement("i");
	icon.classList.add("icon");
	icon.innerText = option.icon;

	element.appendChild(icon);
	element.appendChild(text);
	container.appendChild(element);

	element.onselect = function() {
		for (var i = index + 1; i < Containers.length; i++) {
			removeContainer(i);
		}

		if (option.sub) {
			for (var subOption of option.sub) {
				createElement(index + 1, subOption);
			}

			orderElements(index + 1, element);
		}
	};

	element.onclick = function() {
		Root.style.display = "none";
		post("selectNavigation", option.id);
	};

	return element;
}

function orderElements(index, around) {
	var container = getContainer(index);

	var sliceCount = container.childNodes.length;
	var sliceAngle = 360.0 / sliceCount;
	var angle = -90.0;

	if (around) {
		var aroundAngle = getAngleFromElement(around);

		sliceAngle = 22.5;
		angle = aroundAngle + 90 - sliceAngle * (sliceCount - 1) / 2.0;
	}

	sortNode(container);

	container.childNodes.forEach(element => {
		var offset = getOffsetAroundCenter(angle, CenterOffset + index * SubOffset);

		element.style.left = `${offset.x}vmin`;
		element.style.top = `${offset.y}vmin`;
		
		angle += sliceAngle;
	});
}

function getOffsetAroundCenter(angle, radius) {
	var rad = Deg2Rad * angle;

	return {
		x: Math.cos(rad) * radius,
		y: Math.sin(rad) * radius,
	}
}

function getAngleFromElement(element) {
	var x = element.offsetTop;
	var y = element.offsetLeft;
	
	return Math.atan2(-y, x) * Rad2Deg;
}

function getDistanceFromElement(element) {
	var x = element.offsetTop;
	var y = element.offsetLeft;
	
	return getDistance(x, y, screen.width / 2, screen.height / 2);
}

function getDistance(x1, y1, x2, y2) {
	return Math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2);
}

function sortNode(element) {
	var items = element.childNodes;
	var itemsArr = [];
	for (var i in items) {
		if (items[i].nodeType == 1) {
			itemsArr.push(items[i]);
		}
	}

	itemsArr.sort(function(a, b) {
		return a.innerHTML == b.innerHTML ? 0 : (a.innerHTML > b.innerHTML ? 1 : -1);
	});

	for (i = 0; i < itemsArr.length; ++i) {
		element.appendChild(itemsArr[i]);
	}
}