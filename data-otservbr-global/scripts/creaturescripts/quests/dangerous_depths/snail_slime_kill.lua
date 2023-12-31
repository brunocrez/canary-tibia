local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONHIT)

local area = createCombatArea(AREA_CIRCLE2X2)
combat:setArea(area)

local monsters = {
	"the count of the core",
}

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	if tile then
		local target = tile:getTopCreature()
		if target and target ~= cid then
			targetName = target:getName():lower()
			casterName = cid:getName():lower()
			if table.contains(monsters, targetName) and casterName ~= targetName then
				target:addHealth(math.random(0, 2000))
			end
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function summonSlimes(master)
	local contador = 0
	local slimeCheck = Game.getSpectators(master:getPosition(), false, false, 20, 20, 20, 20)
	for _, slime in pairs(slimeCheck) do
		if slime:isMonster() then
			if slime:getName():lower() == "snail slime" then
				contador = contador + 1
			end
		end
	end
	if contador < 3 then
		local summon = Game.createMonster("Snail Slime", master:getPosition(), true)
		if summon then
			summon:registerEvent("SnailSlimeKill")
		end
	end
end

local snailSlimeThink = CreatureEvent("SnailSlimeThink")
function snailSlimeThink.onThink(creature)
	if not creature:isMonster() then
		return true
	end
	if creature:getName():lower() == "the count of the core" then
		local percHealth = (creature:getHealth() / creature:getMaxHealth()) * 100
		if percHealth <= 50 then
			summonSlimes(creature)
		end
	end
	return true
end

snailSlimeThink:register()

local snailSlimeKill = CreatureEvent("SnailSlimeKill")
function snailSlimeKill.onKill(player, creature)
	if not player:isPlayer() then
		return true
	end
	if not creature:isMonster() or creature:getMaster() then
		return true
	end

	local monsterName = creature:getName():lower()
	if monsterName == "snail slime" then
		if not creature then
			return
		end
		creature:say("!!", TALKTYPE_ORANGE_2)
		local var = { type = 1, number = creature:getId() }
		combat:execute(creature, var)
	end
	return true
end

snailSlimeKill:register()
