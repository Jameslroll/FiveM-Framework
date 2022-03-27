const Config = {
	FactionThreshold: 1, // The threshold above the minimum that is protected by faction.
	MinFrequency: 137, // The minimum frequency the radio supports.
	MaxFrequency: 480, // The maximum frequency the radio supports.
	MaxAdditionals: 4, // How many additional channels can be listened to at once.
	VolumeSteps: 6, // How many turns on the knob (changes the step to reach 100%).
	EmptyText: "---.--", // Text displayed before typing frequency.
};

let IsDefault = true;
let IsFactionLocked = true;
let AudioObjects = {};
let Additional = 0;
let Additionals = {};
let Channels = {};
let Channel = 1;
let Volume = 0.0;
let Frequency = undefined;

const MainNode = document.querySelector("#main");
const FrequencyNode = document.querySelector("#screen #frequency");
const ChannelNode = document.querySelector("#screen #channel");
const LabelsNode = document.querySelector("#volume #labels");

document.addEventListener("DOMContentLoaded", function() {
	updateVolume(0);
	setChannel(1, true);
	setFrequency();
});

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.method) {
		var func = window[data.method];
		if (func) {
			func(...data.data);
		}
	}
});

document.querySelector("#clear").onclick = function(e) {
	setFrequency();
	playClick();
};

document.querySelector("#set-frequency").onclick = function(e) {
	setFrequency(FrequencyNode.textContent);
	playClick();
};

document.onkeydown = function(e) {
	var key = e.key;
	var frequency = FrequencyNode.textContent;
	
	if (key == "Enter") {
		e.preventDefault();

		setFrequency(frequency);
		playClick();
		
		return
	}
	
	if ((key == "." && !frequency.includes(".")) || !isNaN(parseFloat(key))) {
		// Reset default.
		if (IsDefault) {
			frequency = "";
		}

		// Append string.
		frequency += key;

		// Get left and right from decimal.
		var [left, right] = frequency.split(/[(.+)\.?(.+)]/g);
		
		// Get left number.
		left = parseInt(left);
		if (isNaN(left)) left = undefined;

		// Limit maximum always.
		if (left) {
			left = Math.min(left, Config.MaxFrequency);
		}
		
		// Limit minimum when left-side is done.
		if (right || key == ".") {
			left = Math.max(left, getMinimumFrequency());
		}

		// Limit right-side to two decimals.
		if (right) {
			right = right.substring(0, 2);
		}

		// Auto fill left-side
		if ((key == "." || right) && !left) {
			left = 0;
		}

		// Re-build frequency.
		frequency = `${left != undefined ? left : ""}${right != undefined || key == "." ? "." : ""}${right != undefined ? right : ""}`;
	} else if (key == "Backspace") {
		// Remove last character.
		frequency = IsDefault ? "" : frequency.substring(0, frequency.length - 1);
	}

	if (FrequencyNode.textContent != frequency) {
		IsDefault = false;
		FrequencyNode.textContent = frequency;

		if (Frequency == frequency) {
			FrequencyNode.classList.remove("unset");
		} else {
			FrequencyNode.classList.add("unset");
		}
		
		playClick();
	}
};

function post(callback, payload) {
	if (window["GetParentResourceName"] == undefined) {
		console.log("post", callback, payload);
		return
	}

	fetch(`http://${GetParentResourceName()}/${callback}`, {
		method: "POST",
		headers: { "Content-Type": "application/json; charset=UTF-8" },
		body: JSON.stringify(payload)
	});
}

function invoke(method) {
	post("invoke", {
		method: method,
		data: Array.prototype.slice.call(arguments, invoke.length),
	});
}

function reset() {
	FrequencyNode.textContent = Config.EmptyText;
	FrequencyNode.classList.remove("unset");

	ChannelNode.innerText = `C1`;
	
	IsDefault = true;
	Additional = 0;
	Additionals = {};
	Channel = 1;
	Channels = {};
	Volume = 0.0;
	IsFactionLocked = true;

	updateVolume(0);
}

function setVisible(value, isFactionLocked) {
	MainNode.style.display = value ? "block" : "none";
	IsFactionLocked = isFactionLocked;
}

function getMinimumFrequency() {
	return Config.MinFrequency + (IsFactionLocked ? Config.FactionThreshold : 0);
}

function playClick() {
	playSound("click", 0.4);
}

function playSound(name, volume) {
	var clip = AudioObjects[name];
	if (!clip) {
		clip = new Audio(`sound/${name}.ogg`);
		AudioObjects[name] = clip;
	}

	clip.volume = volume ?? 1.0;
	clip.play();
}

function checkInput(e) {
	var value = e.value.replace(/[^0-9.]+/g, "");
	value = parseFloat(value);
	value = Math.min(Math.max(isNaN(value) ? 60.0 : value, 0.01), 999.99).toFixed(2);

	e.value = value;
}

function setFrequency(value) {
	if (Additional) {
		Additionals[Additional] = value;
	} else {
		Channels[Channel] = value;
	}

	if (value && value != "") {
		var fValue = parseFloat(value);
		if (!isNaN(fValue)) {
			value = Math.max(Math.min(fValue, Config.MaxFrequency), getMinimumFrequency()).toFixed(2);
		}
		IsDefault = false;
	} else {
		value = Config.EmptyText;
		IsDefault = true;
	}
	
	invoke("SetFrequency", IsDefault ? "" : value, Additional);

	Frequency = value;

	FrequencyNode.textContent = value;
	FrequencyNode.classList.remove("unset");
}

function setChannel(channel, noSound) {
	ChannelNode.innerText = `C${channel}`;
	Channel = channel;
	Additional = 0;

	setFrequency(Channels[channel]);

	if (!noSound) {
		playClick();
	}
}

function setAdditional(value, direct) {
	var additional = Additional;

	if (direct) {
		additional = value;
	} else {
		additional += value;
	}

	additional = Math.min(Math.max(additional, 0), Config.MaxAdditionals);

	if (Additional != additional) {
		Additional = additional;

		if (additional) {
			ChannelNode.innerText = `A${additional}`;
	
			setFrequency(Additionals[additional]);
		} else {
			setChannel(Channel);
		}

		playClick();
	}
}

function updateVolume(value) {
	Volume = value;
	
	const options = [
		(value - 1) || "OFF",
		value || "OFF",
		value + 1,
	];

	if (options[0] < 0) {
		options[0] = "";
	}
	
	if (options[2] > Config.VolumeSteps) {
		options[2] = "";
	}
	
	for (let index = 0; index < LabelsNode.children.length; index++) {
		const child = LabelsNode.children[index];
		const option = options[index];

		child.textContent = option;

		if (option == "OFF") {
			child.classList?.add("off");
		} else {
			child.classList?.remove("off");
		}
	}
}

function setVolume(value) {
	var volume = Math.min(Math.max(Volume + value, 0), Config.VolumeSteps);
	if (Volume == volume) return;

	updateVolume(volume);

	playSound("snap", 0.4);

	invoke("SetVolume", volume / Config.VolumeSteps);
}