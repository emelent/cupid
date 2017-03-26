local player = {
  image = nil,
  direction = 0,
  speed = 150,
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
  -- keys = {
  --   left = ret('a', 'left'),
  --   right = ret('d', 'right'),
  --   down = ret('s', 'down'),
  --   up = ret('w', 'up'),
  --   interact = ret('e')
  -- }
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

  --Add animations
  sprite:addAnimation('idle', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    frames = {
      {1, 1, 6, 1, .15}
    }
  })
  sprite:addAnimation('walking', {
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
    onReachedEnd = function()
      player.smAction:setState('idle')
    end,
    frames = {
      {1, 3, 6, 3, .08}
    }
  })
  sprite:addAnimation('end-slash', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd = true,
    onReachedEnd = function()
      player.smAction:setState('idle')
    end,
    frames = {
      {4,3,6,3, 0.1}
    }
  })
  sprite:addAnimation('power-slash', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd    = true,
    onReachedEnd = function() 
      player.smAction:setState('idle')
    end,
    frames = {
      {1, 4, 6, 4, .08}
    }
  })
  sprite:addAnimation('end-power-slash', {
    image = image,
    frameWidth = 48,
    frameHeight = 48,
    stopAtEnd = true,
    onReachedEnd = function()
      player.smAction:setState('idle')
    end,
    frames = {
      {4,4,6,4, 0.1}
    }
  })

--set image scale
  sprite.sx = player.scale.x
  sprite.sy = player.scale.y
  player.sprite = sprite
--load states
  local states_dir = 'player_states/'
  player.smAction:loadState('idle', require(states_dir .. 'idle'), {player = player})
  player.smAction:loadState('walking', require(states_dir .. 'walking'), {player = player})

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
