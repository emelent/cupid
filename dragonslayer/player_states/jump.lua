local jump = {
	next_state = 'idle',
	next_args = {}
}

local player
local fsm

local tag = 'JMP'
function jump.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
end

function jump.enter(prev_state, ...)
	local params = ...
	player.sprite:switch('jump')
  player.velocity.y = -player.jumpForce
  player.gravity = true
end

function jump.exit()
	jump.next_args = {}
	jump.next_state = 'idle'
  player.velocity.x = 0
  player.velocity.y = 0
end

function jump.update(dt)
  player.velocity.x = (player.direction * player.speed)

  -- if player lands switch state
  if not player.gravity then
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
