local LSC = LibStub("LibSlashCommander")
LAM = LibStub:GetLibrary("LibAddonMenu-2.0")

local function marco()
    JumpToSpecificHouse("@marcopolo184", 46)
end

local otherPeoplesHouses = {	

	["@marcopolo184"] = {
		["houseIds"] = {
			[46] = "crafting stations",
		},
		["houseCommands"] = {
			[46] = "marco",			
		},
	},

}
myHouses = {
	["@manavortex"] = {
		[1] = 39, 
		[2] = 20, 
		[3] = 45, 
		[4] = 43, 
		[5] = 19,
		[6] = 10,
		[7] = 44,
		[8] = 47,
	}, 
	["@Manorin"] = {
		[1] = 32, 
		[2] = 7, 
		[3] = 5, 
	}, 

}

function GetHouseZoneId()
	d(GetCurrentZoneHouseId())
end

local function registerGoHome(slashCommand, houseId, houseDescription)
	
	local callback = function() 
		d("VisitHome: " .. houseDescription)
		RequestJumpToHouse(tonumber(houseId)) 
	end
	
	LSC:Register(slashCommand, callback, houseDescription)
end

local function getKeyForValue(ary, findme)
	if nil == ary or {} == ary then return end
	for key, value in pairs(ary) do
		if value == findme then return key end
	end
end

local function registerVisitCommand(slashCommand, characterName, houseDescription, houseId)
	
	local callback = function() 
		d("VisitHome: " .. houseDescription)
		JumpToSpecificHouse(tostring(characterName), tonumber(houseId)) 
	end
	
	LSC:Register(slashCommand, callback, houseDescription)
end


function VisitHomes.registerVisitCommands()

	local accountName = GetUnitDisplayName('player')
	
	for playerName, data in pairs(otherPeoplesHouses) do
		local isMine = playerName == accountName
		for houseId, houseDescription in pairs(data.houseIds) do
			local houseCommands = data.houseCommands[houseId]
			if type(houseCommands) == "string" then			
				if isMine then
					registerGoHome("/" .. houseCommands, houseId, houseDescription)
				else				
					registerVisitCommand("/" .. houseCommands, playerName, houseDescription, houseId)
				end
			else
				for index, slashCommand in pairs(houseCommands) do
					if isMine then
						registerGoHome("/" .. slashCommand, houseId, houseDescription)
					else				
						registerVisitCommand("/" .. slashCommand, playerName, houseDescription, houseId)
					end
				end
			end					
		end
	end
	
	if not myHouses[accountName] then return end
	for index, houseId in pairs(myHouses[accountName]) do		
		registerGoHome("/home" .. tostring(index), houseId, GetCollectibleNickname(GetCollectibleIdForHouse(houseId)))
	end
	local houseId = myHouses[accountName][0]
	if nil == SLASH_COMMANDS["/home"] then
		registerGoHome("/home", houseId, GetCollectibleNickname(GetCollectibleIdForHouse(houseId)))
	end
end
