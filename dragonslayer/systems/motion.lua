local motion = tiny.processingSystem()
local GRAVITY = 2000

motion.filter = tiny.requireAll(
  'group',
  'position', 
  'velocity', 
  'hitbox',
  'gravity',
  'reloadHb'
)

local function addHitbox(ent)
  local hb = ent.hitbox
  collidables[ent] = collider:rectangle(hb.x, hb.y, hb.w, hb.h)
end

local function removeHitbox(ent)
  collider:remove(collidables[ent])
end

function motion:onAdd(ent)
  --add entity to physics world
  if collidables[ent]  == nil then
    addHitbox(ent)
  end
end

function motion:onRemove(ent)
  --remove entity from physics world
  removeHitbox(ent)
end

function motion:reloadHitbox(ent)
  removeHitbox(ent)
  addHitbox(ent)
  ent.reloadHb = false
end

function motion:process(ent, dt)
  if ent.reloadHb then
    self:reloadHitbox(ent)
  end
  -- apply gravity 
  if ent.gravity then
    ent.velocity.y = ent.velocity.y + (GRAVITY * dt)
  end

  --update entity hitbox
  local collidable = collidables[ent]
  collidable:moveTo(ent.hitbox.x, ent.hitbox.y)

  --try to move ent to destination, and handle collisions
  local collisions = collider:collisions(collidable)
  local enableGravity = true
  for other, delta in pairs(collisions) do
    ent.setPosition((ent.position + delta):unpack())

    --disable gravity if object bottom is colliding with something
    if delta.y < 0 then
      ent.velocity.y = 0
      enableGravity = false
	-- enable gravity if object hits top
	elseif delta.y > 0 then
		ent.velocity.y = 0
		enableGravity = true
    end
  end
  ent.gravity = enableGravity
end

return motion
