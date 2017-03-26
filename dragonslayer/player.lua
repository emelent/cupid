local player = {
  image = nil,
  direction = 0,
  damageDealt = false,
  speed = 150,
  gravity = 400,
  jumpForce = 100,
  ground = 500,
  state = 'idle',
  smAction = state_machine.newFSM(),
  position = {
    x = 600,
    y = 500
  },
  scale= {
    x = 3,
    y = 3 
  },
}

function player.load()
  --prepare image
  local image = love.graphics.newImage('assets/images/shadow.png')
  -- set image filter
  image:setFilter('nearest', 'nearest')
  player.image = image

  local sprite = sodapop.newAnimatedSprite()
  --anchor sprite to player position
  sprite:setAnchor(function() 
    return player.position.x, player.position.y 
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
    onReachedEnd = switchToNextState,
    frames = {
      {1,5,6,5, 0.05}
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
  sprite.sx = player.scale.x
  sprite.sy = player.scale.y
  player.sprite = sprite

--load states
  local states_dir = 'player_states/'
  player.smAction:loadState('idle', require(states_dir .. 'idle'), {player = player})
  player.smAction:loadState('walk', require(states_dir .. 'walk'), {player = player})
  player.smAction:loadState('slash', require(states_dir .. 'slash'), {player = player})
  player.smAction:loadState('block', require(states_dir .. 'block'), {player = player})
  player.smAction:loadState('crouch', require(states_dir .. 'crouch'), {player = player})
  player.smAction:loadState('jump', require(states_dir .. 'jump'), {player = player})

  -- start off in idle state
  player.smAction:setState('idle')
end

function player.update(dt)
  player.sprite:update(dt)
  player.smAction:stateEvent('update', dt)
end

function player.draw()
  player.smAction:stateEvent('draw')
  player.sprite:draw()
end

function player.keypressed(key, code)
  player.smAction:stateEvent('keypressed', key, code)
end

function player.keyreleased(key, code)
  player.smAction:stateEvent('keyreleased', key, code)
end

return player
