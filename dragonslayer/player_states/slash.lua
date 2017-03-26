local slash = {
	next_state = 'idle',
	next_args = {}
}

local player
local fsm
local direction = 0

function slash.load(...)
	local params = ...
	player = params.player
	fsm = params.player.smAction
end

function slash.enter(prev_state, ...)
	local params = ...
	local ending = false
	if prev_state == 'walk' then
		direction = params.direction
		ending = params.ending
	end
	if ending then
		player.sprite:switch('end_slash')
	else
		player.sprite:switch('slash')
	end
end

function slash.exit()
	direction = 0
	slash.next_args = {}
	slash.next_state = 'idle'
end

function slash.update(dt)
	player.position.x = player.position.x + (direction * player.speed * dt)
	if love.keyboard.isDown('a') then
		slash.next_state = 'walk'
		slash.next_args = {direction = -1}
	elseif love.keyboard.isDown('d') then
		slash.next_state = 'walk'
		slash.next_args = {direction = 1}
	end
end

function slash.keyreleased(key, code)
	if  key == 'a' or key == 'd' then
		slash.next_args = {}
		slash.next_state = 'idle'
		direction = 0
	end
end

return slash
