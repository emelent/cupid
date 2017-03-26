local block = {
	next_state = 'idle',
	next_args = {}
}

local player
local fsm

function block.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
end

function block.enter(prev_state, ...)
	local params = ...

  --stop player motion
  player.direction = 0
	player.sprite:switch('block')
end

function block.exit()
	block.next_args = {}
	block.next_state = 'idle'
end

function block.update(dt)
  if player.damageDealt then
    player.sprite:switch('block')
  end
end

function block.keyreleased(key, code)
  --stop blocking before you damage delt
	if  key == 'up' and not player.damageDealt then
    if love.keyboard.isDown('a') then
      fsm:setState('walk', {direction=-1})
    elseif love.keyboard.isDown('d') then
      fsm:setState('walk', {direction=1})
    elseif love.keyboard.isDown('s') then
      fsm:setState('crouch')
    else
      fsm:setState('idle')
    end
	end
end

return block
