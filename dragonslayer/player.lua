
local player = {
  direction = 0,
  speed = 150,
  state = 'idle',
  position = {
    x = 600,
    y = 500
  },

  scale= {
    x = 3,
    y = 3 
  }
}

function player.load()
  local image = love.graphics.newImage('assets/images/shadow.png')
  local sprite = sodapop.newAnimatedSprite()

  --anchor sprite to player position
  sprite:setAnchor(function() 
    return player.position.x, player.position.y 
  end)

  image:setFilter('nearest', 'nearest')

  --add animations
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
    onReachedEnd = function() 
      player.state = 'idle' 
      player.direction = 0
      player.sprite:switch(player.state)
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
      player.state = 'idle' 
      player.direction = 0
      player.sprite:switch(player.state)
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
      player.state = 'idle' 
      player.direction = 0
      player.sprite:switch(player.state)
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
      player.state = 'idle' 
      player.direction = 0
      player.sprite:switch(player.state)
    end,
    frames = {
      {4,4,6,4, 0.1}
    }
  })

  --set image scale
  sprite.sx = player.scale.x
  sprite.sy = player.scale.y

  player.sprite = sprite
  player.image = image
end

function player.update(dt)
  if player.direction > 0 then
    player.position.x = player.position.x + player.speed * dt
  elseif player.direction < 0 then
    player.position.x = player.position.x - player.speed * dt
  end
  if love.keyboard.isDown('left') then
    if player.state == 'idle' then
      player.state = 'walk'
    end
    player.sprite.flipX = true
    player.direction = -1
  elseif love.keyboard.isDown('right') then
    if player.state == 'idle' then
      player.state = 'walk'
    end
    player.sprite.flipX = false
    player.direction = 1
  end
  player.sprite:switch(player.state, true)
  player.sprite:update(dt)
end

function player.draw()
  player.sprite:draw()
end

function player.keypressed(key, code)
  --only respond to keypresses in idle or walk state
  if player.state ~= 'idle' and player.state ~= 'walk' and player.state ~= 'end-slash' then
    return
  end

  if key == 'right' then
    player.state = 'walk'
    player.sprite.flipX = false
    player.direction = 1
  elseif key == 'left' then
    player.state = 'walk'
    player.sprite.flipX = true
    player.direction = -1
  end

  player.sprite:switch(player.state)
end

function player.keyreleased(key, code)
  --only respond to keypresses in idle or walk state
  if player.state ~= 'idle' and player.state ~= 'walk' then
    return
  end

  if key == 'left' or key =='right' then
    player.direction = 0
    player.state = 'idle'
  elseif key == 'space' then
    if player.state == 'walk' then
      player.state = 'end-power-slash'
    else
      player.state = 'power-slash'
    end
    player.direction = 0
  end

  player.sprite:switch(player.state)
end

return player
