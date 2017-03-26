
sodapop = require('lib.sodapop')
timer = require('lib.hump.timer')
--local suit = require('lib/suit')
--
state_machine = require('state_machine')
local player = require('player')

--debug flag
debug = true

function debug_print(tag, message)
  if debug then
    print(string.format('[DEBUG:%s] %s',tag, message))
  end
end

function love.load()
  --love.graphics.setBackgroundColor(255,255,255)
  player.load()
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
