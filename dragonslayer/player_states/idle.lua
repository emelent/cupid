local idle = {}
local player 
local fsm 
-- local keys 

function idle.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
	-- keys = params.player.keys
end

function idle.enter(prev_state, ...)
	local params = ...
	player.direction = 0
	player.sprite:switch('idle')
end

function idle.exit()
end

function idle.update(dt)
	if player.direction > 0 then
    player.position.x = player.position.x + player.speed * dt
  elseif player.direction < 0 then
    player.position.x = player.position.x - player.speed * dt
  end
end

function idle.keypressed(key, code)
	if key == 'left' then
		fsm:setState('slash', {direction = player.direction})
  elseif key == 'a' then
  	fsm:setState('walk', {direction = -1})
  elseif key == 'd' then
  	fsm:setState('walk', {direction = 1})
  elseif key == 'up' then
    fsm:setState('block')
	end
end

function idle.keyreleased(key, code)
end

return idle
