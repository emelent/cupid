
sodapop = require('lib.sodapop')
timer = require('lib.hump.timer')
vector = require('lib.hump.vector')
state_machine = require('state_machine')
tiny = require('lib.tiny')

local sti = require('lib.sti')
local bump = require('lib.bump')
local player = require('entities.player')
local map

bumpWorld = nil
local systemManager
local debug = true


--debug stuff

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
  
  bumpWorld = bump.newWorld(50)
  systemManager =  tiny.world()
  map = sti('assets/maps/map01.lua', {'bump'})
  map:bump_init(bumpWorld)

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
  map:update(dt)
  player.update(dt)
  systemManager:update(dt)
end

function love.draw()
  love.graphics.setColor(255,255,255,255)
  map:draw()
  player.draw()
  love.graphics.print('Gravity: ' .. tostring(player.gravity), 0, 0)
  love.graphics.print('Items: ' .. tostring(bumpWorld:countItems()), 0, 20)
  love.graphics.setColor(255,0,255,255)
  --map:bump_draw(bumpWorld)
  drawCollisions()

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

