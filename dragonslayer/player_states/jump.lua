local jump = {
	next_state = 'idle',
	next_args = {}
}

local player
local fsm

function jump.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
end

function jump.enter(prev_state, ...)
	local params = ...
	player.sprite:switch('jump')
  player.position.y = player.position.y - player.jumpForce
end

function jump.exit()
	jump.next_args = {}
	jump.next_state = 'idle'
end

function jump.update(dt)
  player.position.x = player.position.x + (player.direction * player.speed * dt)
  if player.position.y < player.ground then
    player.position.y = player.position.y + (player.gravity * dt)
  else
    player.position.y = player.ground
    if player.direction == 0 then
      fsm:setState('idle')
    else
      fsm:setState('walk', {direction = player.direction})
    end
  end

  if love.keyboard.isDown('a') then
    player.direction = -1
  elseif love.keyboard.isDown('d') then
    player.direction = 1
  end
end

function jump.keyreleased(key, code)
  if key == 'a' or key == 'd' then
    player.direction = 0
  end
end

return jump
