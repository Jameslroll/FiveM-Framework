var Index = 0;
var Count = 0;
var Options = [];

function addInteraction(data) {
	if (Options[data.id]) {
		return;
	}
	
	var root = document.querySelector("#interaction");
	var options = document.querySelector("#options");

	var instance = document.createElement("span");
	instance.innerHTML = data.text;
	
	options.appendChild(instance);
	Options[data.id] = instance;
	
	if (Count == 0) {
		root.style.display = "flex";
	}
	
	if (Count == (data.index || 0)) {
		instance.classList.add("active");
		Index = data.index;
	}

	Count += 1;
}

function removeInteraction(data) {
	var instance = Options[data.id];

	if (!instance) {
		return;
	}
	
	instance.remove();
	delete Options[data.id];
	
	if (Count == 1) {
		var root = document.querySelector("#interaction");
		root.style.display = "none";
	}

	Count -= 1;
}

function selectInteraction(data) {
	var options = document.querySelector("#options");

	var oldInteraction = options.children[Index];
	var newInteraction = options.children[data.index];

	// Remove class.
	if (oldInteraction) {
		oldInteraction.classList.remove("active");
	}

	// Add class.
	if (newInteraction) {
		newInteraction.classList.add("active");
	}
	
	// Set index.
	Index = data.index;

}