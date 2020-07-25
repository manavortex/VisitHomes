local LSC = LibSlashCommander

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
VisitHomes.otherPeoplesHouses = otherPeoplesHouses

local myHouses = {
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
VisitHomes.myHouses = myHouses

function GetHouseZoneId() d(GetCurrentZoneHouseId()) end

local function registerVisitCommand(slashCommand, houseId, houseDescription, characterName)

	houseDescription = houseDescription or GetCollectibleNickname(GetCollectibleIdForHouse(houseId))

	local cbFunc = RequestJumpToHouse 
	local args = tonumber(houseId)
	if characterName then
		cbFunc = JumpToSpecificHouse
		args = tostring(characterName), tonumber(houseId)
	
	end
	LSC:Register("/"..slashCommand, function() 
		d("VisitHome: " .. houseDescription)
		cbFunc(args)
	end, houseDescription)
end

local TYPE_STRING = "string"
function VisitHomes.registerVisitCommands()

	local accountName = GetUnitDisplayName('player')
	
	for playerName, data in pairs(otherPeoplesHouses) do
		local ownerName = (playerName == accountName and playerName)
		for houseId, houseDescription in pairs(data.houseIds) do
			local houseCommands = data.houseCommands[houseId]
			if type(houseCommands) == TYPE_STRING then
				registerVisitCommand(houseCommands, houseId, houseDescription, ownerName)
			else
				for index, slashCommand in pairs(houseCommands) do
					registerVisitCommand(slashCommand, houseId, houseDescription, ownerName)
				end
			end					
		end
	end
	
	if not myHouses[accountName] then return end
	
	for index, houseId in pairs(myHouses[accountName]) do
		registerVisitCommand("home" .. tostring(index), houseId)
	end
	
	local houseId = myHouses[accountName][1]
	if houseId and not SLASH_COMMANDS["/home"] then
		registerVisitCommand("home", houseId)
	end
end
