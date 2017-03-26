
sodapop = require('lib/sodapop')
--local suit = require('lib/suit')
--
state_machine = require('state_machine')
local player = require('player')


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
