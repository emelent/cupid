
sodapop = require('lib.sodapop')
timer = require('lib.hump.timer')
vector = require('lib.hump.vector')
state_machine = require('state_machine')

local bump = require('lib.bump')
local tiny = require('lib.tiny')
local player = require('player')


local MotionSystem
local entWorld
local bumpWorld
local ground = {
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

  --Setup Motion System
  MotionSystem = tiny.processingSystem()
    MotionSystem.filter = tiny.requireAll(
      'position', 
      'velocity', 
      'hitbox'
    )

    function MotionSystem:onAdd(ent)
      --add entity to physics world
      bumpWorld:add(
        ent, 
        ent.hitbox.x,
        ent.hitbox.y,
        ent.hitbox.w,
        ent.hitbox.h
      )
    end

    function MotionSystem:onRemove(ent)
      --remove entity from physics world
      bumpWorld:remove(ent)
    end

    function MotionSystem:process(ent, dt)
      --update entity hitbox
      bumpWorld:update(
        ent, 
        ent.hitbox.x,
        ent.hitbox.y,
        ent.hitbox.w,
        ent.hitbox.h
      )

      --try to move player to destination, and handle collisions
      local pos = ent.position
      local filter = function(item, other)
        return 'bounce'
      end

      local actualX, actualY, cols, len = bumpWorld:move(ent, pos.x, pos.y, filter)
      --set new collision position
      ent.position.x = actualX
      ent.position.y = actualY

      for i=1, len do
        debug_print('MotionSysem', 'Collided with ' .. tostring(cols[i].other))
      end
      
        
    end

  -- Setup systems
  entWorld =  tiny.world()
  entWorld:addSystem(MotionSystem)

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
  entWorld:addEntity(player)

end

function love.update(dt)
  player.update(dt)
  entWorld:update(dt)
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
