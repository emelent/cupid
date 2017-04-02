local walk = {}
local player
local fsm

function walk.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
end

function walk.enter(prev_state, ...)
	local params = ...
	player.direction = params.direction 
  player.velocity.x = (player.direction * player.speed)
	player.sprite.flipX = (player.direction < 0)
	player.sprite:switch('walk')
end

function walk.exit()
	-- stop moving
	player.direction = 0
  player.velocity.x = 0
end

function walk.keypressed(key, code)
	if key == 'left' then
		fsm:setState('slash', {direction = player.direction, ending=true})
  elseif key == 'right' then
    fsm:setState('dash', {direction = player.direction})
  elseif key == 'up' then
    fsm:setState('block')
  elseif key == 'down' then
  elseif key == 's' then
    fsm:setState('crouch')
  elseif key == 'w' and not player.gravity then
    fsm:setState('jump')
	end
end

function walk.keyreleased(key, code)
	if key == 'a' or key == 'd' then
		fsm:setState('idle')
	end
end

return walk
