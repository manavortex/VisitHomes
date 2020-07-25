VisitHomes = {}

function VisitHomes.Initialize(eventCode, addOnName)

	if (addOnName ~= "VisitHomes") then return end	
		
	VisitHomes.registerVisitCommands()
	
	EVENT_MANAGER:UnregisterForEvent("VisitHomes", EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent("VisitHomes", EVENT_ADD_ON_LOADED, function(...) VisitHomes.Initialize(...) 	end)




