local motion = tiny.processingSystem()
local gravity = 2000

motion.filter = tiny.requireAll(
  'group',
  'position', 
  'velocity', 
  'hitbox',
  'gravity'
)

function motion:onAdd(ent)
  --add entity to physics world
  bumpWorld:add(
    ent, 
    ent.hitbox.x,
    ent.hitbox.y,
    ent.hitbox.w,
    ent.hitbox.h
  )
end

function motion:onRemove(ent)
  --remove entity from physics world
  bumpWorld:remove(ent)
end

function motion:process(ent, dt)

  -- apply gravity 
  if ent.gravity then
    ent.velocity.y = ent.velocity.y + (gravity * dt)
  end
  --update entity hitbox
  bumpWorld:update(
    ent, 
    ent.hitbox.x,
    ent.hitbox.y,
    ent.hitbox.w,
    ent.hitbox.h
  )

  --try to move ent to destination, and handle collisions
    local pos = ent.position
    local filter = function(item, other)
      return 'cross'
    end

    local goalX, goalY = pos.x, pos.y
    local actualX, actualY, cols, len = bumpWorld:move(ent, goalX, goalY, filter)

    --set new collision position
      ent.position.x = actualX
      ent.position.y = actualY
      local hb = ent.hitboxes[ent.hitbox_name]
      ent.hitbox.x = ent.position.x + (hb.x * ent.sx)
      ent.hitbox.y = ent.position.y + (hb.y * ent.sy)

      local gravity = ent.gravity
      for i=1, len do
        -- disable gravity if bottom colliding
        if cols[i].normal.y == 1 then
          print('disabling gravity')
          gravity = false
          --align with bottom object
          local x,y = bumpWorld:getRect(cols[i].other)
          ent.velocity.y = 0
          ent.position.y = ent.position.y - 1
          ent.hitbox.y = ent.hitbox.y - 1
        end
      end
      --if len == 0 then
        --gravity = true
      --end
      ent.gravity = gravity  
    -- debug info
      for i=1, len do
        debug_print('MotionSysem', 'Vecor normal => ' .. cols[i].normal.x .. ', ' .. cols[i].normal.y)
      end

      bumpWorld:update(
        ent, 
        ent.hitbox.x,
        ent.hitbox.y,
        ent.hitbox.w,
        ent.hitbox.h
      )
end

return motion
