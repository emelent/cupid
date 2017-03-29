
sodapop = require('lib.sodapop')
timer = require('lib.hump.timer')
vector = require('lib.hump.vector')
state_machine = require('state_machine')

local tiny = require('lib.tiny')
local player = require('player')


local sysCollision
local entWorld
local bumpWorld

--debug flag
local debug = true

function debug_print(tag, message)
  if debug then
    print(string.format('[DEBUG:%s] %s',tag, message))
  end
end

function love.load()
  player.load()

  sysCollision = tiny.processingSystem()
  sysCollision.filter = tiny.requireAll(
    'position', 
    'velocity', 
    'hitbox'
  )

  function sysCollision:process(ent, dt)
    --update entity hitbox
    bumpWorld:update(item, table:unpack(ent.hitbox))

    --check for collisions
    
  end

  function sysCollision:onAdd(ent)
    --add entity to physics world
    bumpWorld.add(ent, table:unpack(ent.hitbox))
  end

  function sysCollision:onRemove(ent)
    --remove entity from physics world
    bumpWorld.remove(ent)
  end

  entWorld =  tiny.world()
  entWorld:addSystem(sysCollision)

end

function love.update(dt)
  player.update(dt)
end

function love.draw()
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
