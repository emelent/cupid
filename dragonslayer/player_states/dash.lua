local dash = {
	next_state = 'idle',
	next_args = {}
}

local player
local fsm
local dashTimer = timer.new()
local direction

function dash.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
end

function dash.enter(prev_state, ...)
	local params = ...
  direction = params.direction
	player.sprite:switch('dash')
  dashTimer:after(0.05, function() 
    fsm:setState(dash.next_state, dash.next_args)
  end)
end

function dash.exit()
	dash.next_args = {}
	dash.next_state = 'idle'
end

function dash.update(dt)
  player.position.x = player.position.x + (player.speed * 20 * direction * dt)
  dashTimer:update(dt)
  if love.keyboard.isDown('a') then
    dash.next_args.direction = -1
    dash.next_state = 'walk'
  elseif love.keyboard.isDown('d') then
    dash.next_args.direction = 1
    dash.next_state = 'walk'
  end
end

function dash.keyreleased(key, code)
  if key == 'a' or key == 'd' then
    dash.next_args.direction = 0
    dash.next_state = 'idle'
  end
end

return dash
