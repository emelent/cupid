
sodapop = require('lib.sodapop')
timer = require('lib.hump.timer')
vector = require('lib.hump.vector')
state_machine = require('state_machine')
tiny = require('lib.tiny')

local bump = require('lib.bump')
local player = require('player')


local systems

bumpWorld = nil
local ground = {
  group = 'Ground',
  hitbox =  {
    x = 0,
    y = 550,
    w = 500,
    h = 50
  }
}

--debug flag
local debug = true

function debug_print(tag, message)
  if debug then
    print(string.format('[DEBUG:%s] %s',tag, message))
  end
end

function love.load()
  -- Prepare world
  bumpWorld = bump.newWorld(50)

  -- Setup systems
  local MotionSystem = require('systems.motion')
  --local GravitySystem = require('systems.motion')
  
  systems =  tiny.world()
  systems:addSystem(MotionSystem)

  -- add ground to world
  bumpWorld:add(
    ground, 
    ground.hitbox.x, 
    ground.hitbox.y,
    ground.hitbox.w,
    ground.hitbox.h
  )

  -- prepare player
  player.load()
  
  -- add player to motion system
  systems:addEntity(player)

end

function love.update(dt)
  player.update(dt)
  systems:update(dt)
end

function love.draw()
  love.graphics.setColor(255,0,255,255)
  love.graphics.rectangle(
    'line',
    ground.hitbox.x,
    ground.hitbox.y,
    ground.hitbox.w,
    ground.hitbox.h
  )
  love.graphics.rectangle(
    'line',
    player.hitbox.x,
    player.hitbox.y,
    player.hitbox.w,
    player.hitbox.h
  )

  love.graphics.setColor(255,255,255,255)
  player.draw()
end

function love.keyreleased(key, code)
  if key == 'escape' then
    love.event.quit()
  end
  player.keyreleased(key, code)
end

function love.keypressed(key, code)
  player.keypressed(key, code)
end
