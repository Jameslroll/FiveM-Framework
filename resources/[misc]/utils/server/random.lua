RandomSeed = os.time()

function UpdateSeed()
	RandomSeed = math.random(2147483648)
	math.randomseed(RandomSeed)
end

UpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
LowerCase = "abcdefghijklmnopqrstuvwxyz"
Numbers = "0123456789"
Symbols = "!@#$%&()*+-,./\\:;<=>?^[]{}"

function GetRandomText(length, ...)
	local args = {...}
	local input = ""

	for _, charSet in ipairs(args) do
		input = input..charSet
	end

	local output = ""

	for i = 1, length do
		UpdateSeed()

		local rand = math.random(#input)
		output = output..input:sub(rand, rand)
	end

	return output
end

function GetRandomFloatInRange(min, max)
	UpdateSeed()
	return math.random() * (max - min) + min
end

function GetRandomIntInRange(min, max)
	UpdateSeed()
	return math.random(min, max)
end