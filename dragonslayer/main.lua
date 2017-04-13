
sodapop = require('lib.sodapop')
timer = require('lib.hump.timer')
vector = require('lib.hump.vector')
state_machine = require('state_machine')
tiny = require('lib.tiny')

local sti = require('lib.sti')
local hc = require('lib.hc')
local player = require('entities.player')
local map

local systemManager
local debug = true 

collider = hc.new()
collidables = {}


--debug stuff

  function debug_print(tag, message)
    if debug then
      print(string.format('[DEBUG:%s] %s',tag, message))
    end
  end

  local function drawCollisions()
    for _, item in pairs(collidables) do
      item:draw('line')
    end
  end

function printKeys(tbl)
  for k, v in pairs(tbl) do
    print(k)
  end
  print()
end
local function loadMapCollidables(map, collider)
  local layer = map.layers['Collision']
  printKeys(layer)
  for k, obj in pairs(layer.objects) do
    if obj.shape == 'rectangle' then
      collidables[k] = collider:rectangle(obj.x, obj.y, obj.width, obj.height) 
    end
  end
end

-- love stuff
function love.load()
  
  systemManager =  tiny.world()
  map = sti('assets/maps/map01.lua')
  -- load map objects 
  loadMapCollidables(map, collider) 
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
      entity.load()

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
  -- Scale world
  local scale = 1
  local screen_width = love.graphics.getWidth() / scale
  local screen_height = love.graphics.getHeight() / scale

    -- Translate world so that player is always centred
  local tx = math.floor(player.position.x - screen_width / 2)
  local ty = math.floor(player.position.y - screen_height / 2)

  love.graphics.print('Gravity: ' .. tostring(player.gravity), 0, 0)
  love.graphics.print('Debug: ' .. tostring(debug), 0, 20)
  love.graphics.print(string.format('Player.position: %s, %s', player.position.x, player.position.y), 0, 30)
  love.graphics.print(string.format('Player.velocity: %s, %s', player.velocity.x, player.velocity.y), 0, 40)
  love.graphics.print(string.format('Player.hitbox: %s, %s', player.hitbox.x, player.hitbox.y), 0, 50)
  love.graphics.translate(-tx, -ty)
  love.graphics.scale(scale)

  map:draw()
  player.draw()
  love.graphics.setColor(255,0,255)
  if debug then
    drawCollisions()
  end

end

function love.keyreleased(key, code)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'tab' then
    debug = not debug
  end
  player.keyreleased(key, code)
end

function love.keypressed(key, code)
  player.keypressed(key, code)
end

