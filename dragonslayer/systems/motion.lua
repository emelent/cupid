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

  --try to move player to destination, and handle collisions
    local pos = ent.position
    local filter = function(item, other)
      return 'cross'
    end

    local goalX, goalY = pos.x, pos.y
    local actualX, actualY, cols, len = bumpWorld:move(ent, goalX, goalY, filter)

    --set new collision position
      ent.position.x = actualX
      ent.position.y = actualY

      local gravity = true 
      for i=1, len do
        print('checking')
        -- enable gravity if bottom not colliding
        if cols[i].normal.y ~= -1 then
          print('no bottom collision')
        elseif cols[i].normal.y == -1 then
          gravity = false
          --align with bottom object
          print('bottom collision')
          ent.position.y = cols[i].other.hitbox.y - ent.hitbox.h
        end
      end
      ent.gravity = gravity  
    -- debug info
      for i=1, len do
        debug_print('MotionSysem', ent.group .. ' entity collided with ' .. tostring(cols[i].other.group))
        debug_print('MotionSysem', 'Vecor normal => ' .. cols[i].normal.x .. ', ' .. cols[i].normal.y)

      end
end

return motion
