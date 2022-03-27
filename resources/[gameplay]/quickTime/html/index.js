class Progress {
	constructor(id) {
		this.el = document.querySelector(`#${id}`)
		this.radius = this.el.r.baseVal.value
		this.circumference = this.radius * 2.0 * Math.PI
		
		this.el.style.strokeDasharray = `${this.circumference} ${this.circumference}`
		this.el.style.strokeDashoffset = `${this.circumference}`
	}

	set(from, to) {
		var el = this.el
		const offset = this.circumference - (to - from) * this.circumference
		el.style.strokeDashoffset = offset
		el.style.transform = `rotate(${from * 360.0 - 90.0}deg)`
	}
}

let Interval = null
let LastUpdate = null

document.addEventListener("DOMContentLoaded", function() {
	StartAudio = new Audio("assets/start.ogg")
	SuccessAudio = new Audio("assets/success.ogg")
	FailAudio = new Audio("assets/fail.ogg")

	Root = document.querySelector("body")
	GoalProgress = new Progress("progressGoal")
	CursorProgress = new Progress("progressCursor")
	OuterProgress = new Progress("progressOuter")

	// window.postMessage({ play: { stages: 20 } })
})

window.addEventListener("message", function(event) {
	var data = event.data
	if (!data) return

	if (data.cancel != undefined) {
		if (data.cancel === true) {
			Score = GoalScore
		}

		endGame()

		return
	}

	var play = data.play
	if (play) {
		Score = 0
		GoalScore = play.stages ?? 1
		Speed = play.speed ?? 1.5

		OuterProgress.set(0.0, 0.0)
	
		startCircle(play.goalSize ?? 0.25, play.cursorSize ?? 0.02)
	}
})

window.addEventListener("mousedown", function(e) {
	stopCircle()
})

function startCircle(goalSize, cursorSize) {
	Root.style.display = "block"

	GoalSize = goalSize
	CursorSize = cursorSize

	GoalStart = Math.random()
	GoalEnd = GoalStart + GoalSize

	var minStart = (1.0 - GoalSize) * 0.5
	var maxStart = 1.0 - (GoalEnd - GoalStart) - CursorSize

	CursorOffset = (GoalEnd - GoalStart) * 0.5 + CursorSize * 0.5 + minStart + Math.random() * (maxStart - minStart)
	CursorPosition = (GoalEnd + GoalStart) * 0.5 - CursorSize * 0.5 - CursorOffset

	GoalProgress.set(GoalStart, GoalEnd)
	CursorProgress.set(CursorPosition, CursorPosition + CursorSize)

	Interval = setInterval(updateCircle, 0)

	StartAudio.play()
}

function updateCircle() {
	if(!LastUpdate) {
		LastUpdate = Date.now()
		return
	}

	var delta = (Date.now() - LastUpdate) / 1000
	LastUpdate = Date.now()

	CursorPosition += Speed * delta
	var hasFailed = CursorPosition > GoalEnd

	CursorPosition = Math.min(CursorPosition, GoalEnd)
	CursorProgress.set(CursorPosition, CursorPosition + CursorSize)

	if (hasFailed) {
		stopCircle()
	}
}

function stopCircle() {
	if (!Interval) return

	clearInterval(Interval)

	Interval = null
	LastUpdate = null

	let success = (CursorPosition + CursorSize) > GoalStart && CursorPosition < GoalEnd

	if (success) {
		Score++
		OuterProgress.el.setAttribute("stroke", CursorProgress.el.getAttribute("stroke"));
		OuterProgress.set(0.0, Score / GoalScore)

		SuccessAudio.currentTime = 0
		SuccessAudio.play()

		setTimeout(endGame, 200 + Math.floor(Math.random() * 500.0))
	} else {
		Score = 0
		OuterProgress.el.setAttribute("stroke", GoalProgress.el.getAttribute("stroke"));
		OuterProgress.set(0.0, 1.0)

		FailAudio.currentTime = 0
		FailAudio.play()

		post("finish", false)

		setTimeout(endGame, 1600)
	}
}

function endGame() {
	var hasFailed = Score == 0

	if (Interval) {
		clearInterval(Interval)
	
		Interval = null
		LastUpdate = null
	}

	if (Score < GoalScore && !hasFailed) {
		startCircle(GoalSize, CursorSize)
	} else {
		Root.style.display = "none"

		if (!hasFailed) {
			post("finish", true)
		}
	}
}

function post(callback, payload) {
	fetch(`https://${GetParentResourceName()}/${callback}`, {
		method: "POST",
		headers: { "Content-Type": "application/json; charset=UTF-8" },
		body: JSON.stringify(payload)
	})
}