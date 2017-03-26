local walking = {}
local player
local fsm
local keys

function walking.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
	keys = player.keys
end

function walking.enter(prev_state, ...)
	local params = ...
	player.direction = params.direction 
	player.sprite.flipX = (player.direction < 0)
	player.sprite:switch('walking')
end

function walking.exit()
	-- stop moving
	player.direction = 0
end

function walking.update(dt)
	player.position.x = player.position.x + (player.direction * player.speed * dt)
end

function walking.keypressed(key, code)

end

function walking.keyreleased(key, code)
	if key =='left' or key == 'a' or key=='right' or key == 'd' then
		fsm:setState('idle')
	end
end

-- function inTable(value, table)
-- 	for _, v in pairs(table) do
-- 		if v == value then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end

return walking