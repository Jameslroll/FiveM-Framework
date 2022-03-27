Citizen.CreateThread(function()
	while true do
		if Config.Modifier == nil or IsControlPressed(0, Config.Modifier) then
			if IsControlJustPressed(0, Config.StartRecording) then
				if IsRecording() then
					StopRecordingAndSaveClip()
				else
					StartRecording(1)
				end
			elseif IsControlJustPressed(0, Config.DiscardRecording) and IsRecording() then
				StopRecordingAndDiscardClip()
			end
		end

		Citizen.Wait(0)
	end
end)