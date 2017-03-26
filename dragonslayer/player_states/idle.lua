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

  if love.keyboard.isDown('a', 'left') then
  	fsm:setState('walking', {direction = -1})
  elseif love.keyboard.isDown('d', 'right') then
  	fsm:setState('walking', {direction = 1})
  end
end

function idle.keypressed(key, code)
	-- add other state switches
end

function idle.keyreleased(key, code)
end

return idle