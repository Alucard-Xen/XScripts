local Summoner = Class("Summoner")

function Summoner:initialize()

	self.actions = {

		ruin       = Action(1, 29664),
		cyclone    = Action(1, 29667),
		stream     = Action(1, 29669),
		aegis      = Action(1, 29670),
		buster     = Action(1, 29671),
		fester     = Action(1, 29672),
		
		bahamut    = Action(1, 29673),
		phoenix    = Action(1, 29678),
	}

	self.menu = nil

end

function Summoner:Load(mainMenu)
	
	self.menu = mainMenu

	self.menu["ACTIONS"]["RANGE_DPS_M"]:subMenu("Summoner", "SMN")
		self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]:checkbox("Use Ruin III",        "RUIN",      true)
		self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]:checkbox("Use Crimson Cyclone", "CYCLONE",   true)
		self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]:checkbox("Use Slipstream",      "STREAM",    true)
		self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]:number("Min Slipstream Enemies","STREAMMIN", 2)
		self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]:checkbox("Use Radiant Aegis",   "AEGIS",     true)
		self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]:checkbox("Use Mountain Buster", "BUSTER",    true)
		self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]:checkbox("Use Fester",          "FESTER",    true)
		self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]:checkbox("Use Bahamut",         "BAHAMUT",   true)
		self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]:checkbox("Use Phoenix",         "PHOENIX",   true)
		

end



function Summoner:Execute(bahamut)

	for i, enemy in ipairs(ObjectManager.GetEnemyPlayers(function(enemy) return enemy.missingHealth > 40000 and enemy.health > 0 end)) do		
		if ObjectManager.EnemiesAroundObject(enemy, 10) > 0 then
			if not bahamut.valid then
				self.actions.bahamut:use(enemy.pos)
				return true
			else
				if self.actions.bahamut:canUse(enemy.id) then
					self.actions.bahamut:use(enemy.pos)
					return true
				end
			end
		end
	end

	return false
end

function Summoner:Tick(getTarget)

	local menu = self.menu["ACTIONS"]["RANGE_DPS_M"]["SMN"]
	
	local bahamut = player:getStatus(3228)

	if menu["BAHAMUT"].bool and  self:Execute(bahamut) then return end
	
	if menu["AEGIS"].bool and self.actions.aegis:canUse() and player.missingHealth > 8000 and ObjectManager.EnemiesAroundObject(player, 10) > 0 then
		self.actions.aegis:use()
		return
	end

	local target = getTarget(25)

	if target.valid then
		if bahamut.valid and menu["RUIN"].bool and self.actions.ruin:canUse(target.id) then
			self.actions.ruin:use(target.id)
		elseif menu["FESTER"].bool and self.actions.fester:canUse(target.id) and target.healthPercent < 50 then
			self.actions.fester:use(target.id)
		elseif menu["CYCLONE"].bool and self.actions.cyclone:canUse(target.id) and ObjectManager.EnemiesAroundObject(target, 5) > 0 then
			self.actions.cyclone:use(target.id)
		elseif menu["BUSTER"].bool and self.actions.buster:canUse(target.id) and ObjectManager.EnemiesAroundObject(target, 5) > 0 then
			self.actions.buster:use(target.id)
		elseif menu["STREAM"].bool and self.actions.stream:canUse(target.id) and ObjectManager.EnemiesAroundObject(target, 10) >= menu["STREAM"].int then
			self.actions.stream:use(target.id)
		elseif menu["RUIN"].bool and self.actions.ruin:canUse(target.id) then
			self.actions.ruin:use(target.id)
		end
	end

end

return Summoner:new()