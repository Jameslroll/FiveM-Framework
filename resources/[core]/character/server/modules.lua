Modules = {}

function Modules:LoadDatabase()
	local references = GetTableReferences("characters", "id")
	self.references = {}
	
	for k, reference in pairs(references) do
		self.references[reference.table] = reference
	end
end