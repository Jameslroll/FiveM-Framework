Slots = {}
Slots.config = {
	sides = 16,
	machines = {
		[`vw_prop_casino_slot_01a`] = 1,
		[`vw_prop_casino_slot_02a`] = 2,
		[`vw_prop_casino_slot_03a`] = 3,
		[`vw_prop_casino_slot_04a`] = 4,
		[`vw_prop_casino_slot_05a`] = 5,
		[`vw_prop_casino_slot_06a`] = 6,
		[`vw_prop_casino_slot_07a`] = 7,
		[`vw_prop_casino_slot_08a`] = 8,
	},
	spinners = {
		vector3(-0.115, 0.047, 0.906),
		vector3(0.005, 0.047, 0.906),
		vector3(0.125, 0.047, 0.906),
	},
}

--[[ Functions: Casino ]]--
Casino:Register(Slots)

--[[ Functions: Slots ]]--
function Slots:GetSpinnerModel(index)
	return GetHashKey("vw_prop_casino_slot_0"..index.."a_reels")
end