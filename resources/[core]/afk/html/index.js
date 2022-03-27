window.addEventListener("message", function(event) {
	var data = event.data;
	var setInput = data.setInput;

	if (setInput != undefined) {
		if (setInput) {
			var input = document.querySelector("#input");
			input.innerHTML = setInput;
		}

		document.querySelector("#main").style.display = setInput ? "block" : "none";
	}
});