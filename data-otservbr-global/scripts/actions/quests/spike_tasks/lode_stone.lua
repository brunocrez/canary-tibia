local transformTo = {
	[19207] = 19216,
	[19216] = 19218,
}

local area = { --area where to teleport
	Position(32152, 32502, 11),
	Position(32365, 32725, 12),
}

local spikeTasksStone = Action()
function spikeTasksStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(SPIKE_MIDDLE_CHARGE_MAIN) ~= 0 then
		return false
	end

	if (target == nil) or not target:isItem() or (target:getId() ~= 19217) then
		return false
	end

	target:transform(19379)
	target:decay()
	if item:getId() == 19218 then
		player:setStorageValue(SPIKE_MIDDLE_CHARGE_MAIN, 1)
		player:getPosition():sendMagicEffect(12)
		player:say("Your tinkering caused some kind of magnetic storm that caused you to get disorientated.", TALKTYPE_MONSTER_SAY)
		item:remove()
	else
		item:transform(transformTo[item:getId()])
		if math.random(100) > 60 then
			player:teleportTo(Position.getFreePosition(area[1], area[2]))
			player:getPosition():sendMagicEffect(11)
		end
	end
	return toPosition:sendMagicEffect(12)
end

for itemId, info in pairs(transformTo) do
	spikeTasksStone:id(itemId)
end
spikeTasksStone:id(21568)

spikeTasksStone:register()
