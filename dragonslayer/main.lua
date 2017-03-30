
sodapop = require('lib.sodapop')
timer = require('lib.hump.timer')
vector = require('lib.hump.vector')
state_machine = require('state_machine')
tiny = require('lib.tiny')

local bump = require('lib.bump')
local player = require('entities.player')


local systemManager

bumpWorld = nil

--debug stuff 
--
  local debug = true

  function debug_print(tag, message)
    if debug then
      print(string.format('[DEBUG:%s] %s',tag, message))
    end
  end

  local function drawCollisions()
    for _, item in pairs(bumpWorld:getItems()) do
      love.graphics.rectangle('line', bumpWorld:getRect(item))
    end
  end

-- love stuff

function love.load()
  -- Prepare world
  bumpWorld = bump.newWorld(50)
  systemManager =  tiny.world()

  -- add ground to world
  bumpWorld:add('ground', 0, 550, 500, 50)

  -- Load systems
    local systems = {}
    local systemNames= require('systems')
    for _, name in pairs(systemNames) do
      systemManager:addSystem(require('systems.' .. name))
    end


  -- Load entities
    local entityNames =  require('entities')
    for _, name in pairs(entityNames) do
      local entity = require('entities.' .. name)  
      -- load entity
      entity:load()

      -- add entity to system manager
      systemManager:addEntity(entity)
    end
end

function love.update(dt)
  player.update(dt)
  systemManager:update(dt)
end

function love.draw()
  love.graphics.setColor(255,0,255,255)
  drawCollisions()
  player.draw()
  love.graphics.print('Gravity: ' .. tostring(player.gravity), 0, 0)
  love.graphics.print('Items: ' .. tostring(bumpWorld:countItems()), 0, 20)
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

