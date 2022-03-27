EnableDebug = false;

$(document).ready(function() {
	if (EnableDebug) {
		window.postMessage({
			display: true
		});
	}
});

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.display != undefined) {
		document.querySelector("#main").style.display = data.display ? "flex" : "none";
	}
});