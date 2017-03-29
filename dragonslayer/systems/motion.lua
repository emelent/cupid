local motion = tiny.processingSystem()

motion.filter = tiny.requireAll(
  'group',
  'position', 
  'velocity', 
  'hitbox'
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
    return 'touch'
  end

  local goalX, goalY = pos.x, pos.y
  local actualX, actualY, cols, len = bumpWorld:move(ent, goalX, goalY, filter)

  --set new collision position
  ent.position.x = actualX
  ent.position.y = actualY

  if len > 0 then
    debug_print('motion', string.format('Goal => (%s, %s)', goalX, goalY))
    debug_print('motion', string.format('Actual => (%s, %s)', actualX, actualY))
  end
  for i=1, len do
    debug_print('MotionSysem', ent.group .. ' entity collided with ' .. tostring(cols[i].other.group))
  end
  
    
end

return motion
