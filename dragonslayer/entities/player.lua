local player = {
  image = nil,
  direction = 0,
  damageDealt = false,
  dashFactor = 20,
  speed = 200,
  gravity = true,
  reloadHb = false,
  jumpForce = 800,
  state = 'idle',
  group = 'Player',
  smAction = state_machine.newFSM(),
  position = vector(0, 0),
  center = vector(0,0),
  velocity = vector(0, 0),
  w = 48,
  h = 48,
  dw = 48,
  dh = 48,
  hb = nil,
  hitboxes = nil,
  hb = nil,
  hitbox = nil,
  sx = 3,
  sy = 3,
}

local block = {}
function player.load()
  --prepare image
  local image = love.graphics.newImage('assets/images/shadow.png')

  -- set image filter
  image:setFilter('nearest', 'nearest')
  player.image = image

  local sprite = sodapop.newAnimatedSprite()
  --anchor sprite to player position
  sprite:setAnchor(function()
    return player.center.x, player.center.y
  end)

  local switchToNextState = function()
    --if there is a next state switch to it
    if player.smAction.current_state.next_state then
      player.smAction:setState(
        player.smAction.current_state.next_state,
        player.smAction.current_state.next_args
      )
    end
  end
  --Add animations
  sprite:addAnimation('idle', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    frames = {
      {1, 1, 6, 1, .15}
    }
  })
  sprite:addAnimation('walk', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    frames = {
      {1, 2, 6, 2, .15}
    }
  })
  sprite:addAnimation('slash', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd    = true,
    onReachedEnd = switchToNextState,
    frames = {
      {1, 3, 6, 3, .08}
    }
  })
  sprite:addAnimation('end_slash', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd = true,
    onReachedEnd = switchToNextState,
    frames = {
      {4,3,6,3, 0.1}
    }
  })
  sprite:addAnimation('power_slash', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd    = true,
    onReachedEnd = switchToNextState,
    frames = {
      {1, 4, 6, 4, .08}
    }
  })
  sprite:addAnimation('end_power_slash', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd = true,
    onReachedEnd = switchToNextState,
    frames = {
      {4,4,6,4, 0.1}
    }
  })
  sprite:addAnimation('dash', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd = true,
    frames = {
      {1,5,3,5, 0.05}
    }
  })
  sprite:addAnimation('end_dash', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    onReachedEnd = switchToNextState,
    stopAtEnd = true,
    frames = {
      {3,5,6,5, 0.05}
    }
  })
  sprite:addAnimation('block', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd = true,
    frames = {
      {1,6,3,6, 0.1}
    }
  })
  sprite:addAnimation('block_damage', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd = true,
    onReachedEnd = function()
      --go to idle after blocking damage
      player.smAction:setState('idle')
      player.damageDealt = false
    end,
    frames = {
      {3,6,6,6, 0.1}
    }
  })

  sprite:addAnimation('crouch', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd = true,
    frames = {
      {1,11,1,11, 0.1}
    }
  })

  sprite:addAnimation('jump', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd = true,
    frames = {
      {2,11,2,11, 0.1}
    }
  })


--set image scale
  sprite.sx = player.sx
  sprite.sy = player.sy
  player.sprite = sprite
  player.hitboxes = require('hitboxes.player_hitbox')

  printKeys(player.hitboxes)
--set player position
  player.setPosition(200, 300)

--load states
  local states_dir = 'player_states/'
  player.smAction:loadState('idle', require(states_dir .. 'idle'), {player = player})
  player.smAction:loadState('walk', require(states_dir .. 'walk'), {player = player})
  player.smAction:loadState('slash', require(states_dir .. 'slash'), {player = player})
  player.smAction:loadState('block', require(states_dir .. 'block'), {player = player})
  player.smAction:loadState('crouch', require(states_dir .. 'crouch'), {player = player})
  player.smAction:loadState('jump', require(states_dir .. 'jump'), {player = player})
  player.smAction:loadState('dash', require(states_dir .. 'dash'), {player = player})

  -- start off in idle state
  player.smAction:setState('idle')
  player.setHitbox('default')
end

function player.setHitbox(hbName)
  print('setting hitbox pos')
  player.hb = player.hitboxes[hbName]
  local x = player.hb.x * player.sx
  local y = player.hb.y * player.sy
  local w  = player.hb.width * player.sx
  local h = player.hb.height * player.sy

  player.hitbox = {
    x = x,
    y = y,
    w = w,
    h = h
  }
  player.reloadHb = true
end

function player.isAirborne()
  return player.velocity.y ~= 0
end

function player.jump()
  player.smAction:setState('jump')
end

function player.setPosition(x, y)
  player.position.x = x
  player.position.y = y
  player.center.x = x + (player.dw/2)
  player.center.y = y + (player.dh/2)

  --update hitbox position
  if player.hitbox ~= nil then
    player.hitbox.x, player.hitbox.y = player.center:unpack() 
  end
end

function player.update(dt)
  player.setPosition((player.position + (player.velocity * dt)):unpack())
  player.smAction:stateEvent('update', dt)
  player.sprite:update(dt)

end

function player.draw()
  player.smAction:stateEvent('draw')
  player.sprite:draw()
end

function player.keypressed(key, code)
  player.smAction:stateEvent('keypressed', key, code)
  if key == 'k' then
    player.position.y = player.position.y + 10
  elseif key == 'i' then
    player.position.y = player.position.y - 10
  elseif key == 'l' then
    player.position.x = player.position.x + 10
  elseif key == 'j' then
    player.position.x = player.position.x - 10
  end
end

function player.keyreleased(key, code)
  player.smAction:stateEvent('keyreleased', key, code)
end

return player
