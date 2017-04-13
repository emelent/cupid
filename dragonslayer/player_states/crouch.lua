local crouch = {
	next_state = 'idle',
	next_args = {}
}

local player
local fsm

function crouch.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
end

function crouch.enter(prev_state, ...)
	local params = ...
  -- stop player motion
  player.direction = 0
	player.sprite:switch('crouch')
  player.setHitbox('crouch')
end

function crouch.exit()
	crouch.next_args = {}
	crouch.next_state = 'idle'
  player.setHitbox('default')
end

function crouch.keyreleased(key, code)
  --stop crouching
	if  key == 's' then
    if love.keyboard.isDown('a') then
      fsm:setState('walk', {direction=-1})
    elseif love.keyboard.isDown('d') then
      fsm:setState('walk', {direction=1})
    else
      fsm:setState('idle')
    end
	end
end

return crouch
