function love.conf(t)
    t.version = '0.10.2'
    t.author = "Merrick Kavolsky"        -- The author of the game (string)

    t.modules.joystick = true   -- Enable the joystick module (boolean)
    t.modules.audio = true      -- Enable the audio module (boolean)
    t.modules.keyboard = true   -- Enable the keyboard module (boolean)
    t.modules.event = true      -- Enable the event module (boolean)
    t.modules.image = true      -- Enable the image module (boolean)
    t.modules.graphics = true   -- Enable the graphics module (boolean)
    t.modules.timer = true      -- Enable the timer module (boolean)
    t.modules.mouse = true      -- Enable the mouse module (boolean)
    t.modules.sound = true      -- Enable the sound module (boolean)
    t.modules.thread = true
    t.modules.physics = true    -- Enable the physics module (boolean)
    t.modules.window = true

    t.window.title = "Demo"        -- The title of the window the game is in (string) 
    t.window.fullscreen = false -- Enable fullscreen (boolean)
    t.window.vsync = false       -- Enable vertical sync (boolean)
    t.window.fsaa = 0           -- The number of FSAA-buffers (number)
    t.window.width = 768        -- The window width (number)
    t.window.height = 640       -- The window height (number)
end
