Marking = Marking or {}

function Marking:CanMark(source)
	return exports.jobs:IsInEmergency(source)
end