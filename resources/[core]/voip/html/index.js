let DebugNode = document.querySelector("#debug");;
let RangeNode = document.querySelector("#voice-range");;
let ErrorNode = document.querySelector("#error");
let ChannelsNode = document.querySelector("#channels");

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.debug != undefined) {
		DebugNode.innerHTML = data.debug
	}
	
	if (data.range != undefined) {
		RangeNode.src = `assets/${data.range.toString()}.png`;
	}

	if (data.talking === true) {
		RangeNode.classList.add("active");
	} else if (data.talking === false) {
		RangeNode.classList.remove("active");
	}

	if (data.connected != undefined) {
		ErrorNode.style.display = data.connected ? "none" : "block";
	}

	if (data.channels != undefined) {
		ChannelsNode.innerHTML = "";

		for (var channel of data.channels) {
			var channelNode = document.createElement("span");
			channelNode.textContent = channel;

			ChannelsNode.appendChild(channelNode);
		}
	}
});