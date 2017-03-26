local jump = {
	next_state = 'idle',
	next_args = {}
}

local player
local fsm
local speed_y = 0

local tag = 'JMP'
function jump.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
end

function jump.enter(prev_state, ...)
	local params = ...
	player.sprite:switch('jump')
  speed_y = -player.jumpForce
end

function jump.exit()
	jump.next_args = {}
	jump.next_state = 'idle'
  speed_y = 0
end

function jump.update(dt)
  speed_y = speed_y + (player.gravity * dt)
  player.position.x = player.position.x + (player.direction * player.speed * dt)
  player.position.y = player.position.y + (speed_y * dt)
  if player.position.y > player.ground then
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
