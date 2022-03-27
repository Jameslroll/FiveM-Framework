const Main = {};

// document.addEventListener("DOMContentLoaded", function() {
// 	window.postMessage({
// 		commit: {
// 			type: "setSite",
// 			data: [
// 				{
// 					cameras: [
// 						{ entity: 389512 },
// 						{ entity: 893241 },
// 						{ entity: 962334 },
// 					],
// 					settings: {
// 						Name: "Toll",
// 						Center: { x: 1906.8707275390625, y: 2606.907470703125, z: 46.52466201782226 },
// 						Radius: 20.0,
// 					},
// 				},
// 				{
// 					cameras: [
						
// 					],
// 					settings: {
// 						Name: "Reception",
// 						Center: { x: 1832.369140625, y: 2589.25830078125, z: 46.20248031616211 },
// 						Radius: 15.0,
// 					},
// 				},
// 				{
// 					cameras: [
						
// 					],
// 					settings: {
// 						Name: "Front",
// 						Center: { x: 1832.369140625, y: 2589.25830078125, z: 46.20248031616211 },
// 						Radius: 50.0,
// 					},
// 				},
// 				{
// 					cameras: [
						
// 					],
// 					settings: {
// 						Name: "Tower A",
// 						Center: { x: 1822.856689453125, y: 2621.3603515625, z: 63.72840118408203 },
// 						Radius: 20.0,
// 					},
// 				},
// 			],
// 		}
// 	})
// });

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.commit) {
		var func = window[data.commit.type];
		if (func) {
			func(data.commit.data)
		}
	}
});

function setDisplay(data) {
	document.querySelector(`#${data.id}`).style.display = data.value ? "flex" : "none";
}

/* Groups */
function setSite(groups) {
	Main.groups = groups;

	var content = document.querySelector("#content");
	content.innerHTML = "";
	
	for (var groupIndex in groups) {
		var group = groups[groupIndex];

		// Create the group node.
		var groupNode = document.createElement("div");
		groupNode.classList.add("site");
		
		group.rootNode = groupNode;
		content.appendChild(groupNode);

		// Create title text.
		var titleNode = document.createElement("span");
		titleNode.classList.add("title");
		titleNode.textContent = group.settings.Name || "Unknown";

		groupNode.appendChild(titleNode);

		// Create cameras.
		var listNode = document.createElement("div");
		listNode.style.display = "none";
		listNode.id = "cameras";
		
		groupNode.appendChild(listNode);

		if (group.cameras != undefined) {
			setCameras({
				groupIndex: groupIndex,
				cameras: group.cameras,
			});
		}

		// Create search text.
		// var searchNode = document.createElement("span");
		// searchNode.classList.add("searching");
		// searchNode.textContent = "Searching";

		// groupNode.appendChild(searchNode);
	}

	setDisplay({
		id: "content",
		value: true,
	});
}

function selectGroup(index) {
	// Get root node.
	var group = Main.groups[index];
	var rootNode = group?.rootNode;

	if (rootNode == undefined) {
		return;
	}
	
	// Clear last selected.
	var lastGroup = Main.lastGroup;
	if (lastGroup != undefined) {
		lastGroup.classList.remove("selected");
		lastGroup.querySelector("#cameras").style.display = "none";
	}

	rootNode.classList.add("selected");
	rootNode.querySelector("#cameras").style.display = "flex";
	
	Main.lastGroup = rootNode;
}

/* Cameras */
function setCameras(data) {
	for (var index in data.cameras) {
		addCamera({
			groupIndex: data.groupIndex,
			camera: data.cameras[index],
		});
	}
}

function addCamera(data) {
	var group = Main.groups[data.groupIndex];
	var rootNode = group?.rootNode?.querySelector("#cameras");

	if (rootNode == undefined) {
		return;
	}

	var cameraNode = document.createElement("span");
	cameraNode.classList.add("camera");
	cameraNode.textContent = data.camera.name;

	rootNode.appendChild(cameraNode);
}

function selectCamera(data) {
	// Get root node.
	var group = Main.groups[data.groupIndex];
	var rootNode = group?.rootNode?.querySelector("#cameras");

	if (rootNode == undefined) {
		return;
	}
	
	// Clear last selected.
	var lastSelected = Main.lastSelected;
	if (lastSelected != undefined) {
		lastSelected.classList.remove("selected");
	}

	// Find camera text.
	var cameraNode = rootNode.children[data.cameraIndex - 1];
	if (cameraNode != undefined) {
		cameraNode.classList.add("selected");
		Main.lastSelected = cameraNode;
	}
}