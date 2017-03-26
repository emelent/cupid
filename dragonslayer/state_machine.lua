local StateMachine = {
  loaded = {},
  current_state = nil
}

local function get_key_for_value(table, value)
  if value == nil then
    return nil
  end
  for k, v in pairs(table) do
    if v == value then
      return k
    end
  end
  return nil
end

function StateMachine:new()
  setmetatable({}, StateMachine)
  return self
end

function StateMachine:loadState(state_name, state, ...)
  self.loaded[state_name] = state
  if state.load and type(state.load) == 'function' then
    print('Loading', state_name)
    state.load(...)
  end
end

function StateMachine:setState(state_name, ...)
  self:stateEvent('exit')
  local prev_state_name = get_key_for_value(self.loaded, self.current_state)
  self.current_state = self.loaded[state_name]
  assert(self.current_state, 'Invalid state name')
  self:stateEvent('enter', prev_state_name, ...)
end

function StateMachine:stateEvent(function_name, ...)
  if self.current_state and type(self.current_state[function_name]) == 'function' then
    self.current_state[function_name](...)
  end
end

return {
  newFSM = function() 
    return StateMachine:new()
  end
}
