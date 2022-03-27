function DateFromTime(time)
	local dob = time / 1000.0
	local offset = 0

	if dob < 0 then
		dob = dob + 4070912400
		offset = 129
	end

	local date = os.date("*t", dob)
	if not date then return end

	return ("%02d/%02d/%04d"):format(
		date.month,
		date.day,
		date.year - offset
	), os.date("%Y", os.time()) - date.year + offset
end

function IsDateValid(month, day, year)
	if day <= 0 or day > 31 or month <= 0 or month > 12 or year <= 0 then
		return false
	elseif month == 4 or month == 6 or month == 9 or month == 11 then
		return day <= 30
	elseif month == 2 then
		if year % 400 == 0 or (year % 100 ~= 0 and year % 4 == 0) then
			return day <= 29
		else
			return day <= 28
		end
	else
		return day <= 31
	end
end