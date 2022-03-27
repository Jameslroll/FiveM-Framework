Items = Items or {}
Items.items = {}

function Items:Cache()
	for treatmentName, treatment in pairs(Config.Treatments) do
		treatment.Name = treatmentName
		if treatment.Item and treatment.Usable then
			self.items[treatment.Item] = treatment
		end
	end
end