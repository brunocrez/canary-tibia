local failPosition = Position(32358, 32224, 7)

local vipTeleport = MoveEvent()

function vipTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:isVip() then
		return true
	end

	player:teleportTo(failPosition)
	failPosition:sendMagicEffect(CONST_ME_POFF)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only VIP players can pass.")
	return true
end

vipTeleport:type("stepin")
vipTeleport:aid(51758)
vipTeleport:register()
