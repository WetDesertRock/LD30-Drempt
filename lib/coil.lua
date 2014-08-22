
local coil = { _version = "0.0.1" }
coil.__index = coil
coil.tasks = {}


local unpack = unpack or table.unpack

local _assert = function(cond, msg, lvl) 
  if cond then return cond, msg, lvl end
  error(msg, lvl + 1)
end



local task = {} 
task.__index = task


function task.new(fn)
  local self = setmetatable({}, task)
  self.routine = coroutine.wrap(fn)
  self.pausecount = 0
  return self
end


function task:pause()
  self.pausecount = self.pausecount + 1
end


function task:resume()
  _assert(self.pausecount > 0, "unbalanced resume()", 2)
  self.pausecount = self.pausecount - 1
end



function coil:update(dt)
  if #self == 0 then return end
  coil.deltatime = dt
  for i = #self, 1, -1 do 
    local task = self[i]
    if task.wait then
      -- Handle wait
      if type(task.wait) == "number" then
        task.wait = task.wait - dt
        if task.wait <= 0 then
          task.waitrem = task.wait
          task.wait = nil
        end
      elseif type(task.wait) == "table" then
        if task.wait.ready then
          task.wait = nil
        end
      end
    end
    if not task.wait and task.pausecount == 0 then
      -- Run task
      coil.current = task
      if not task.routine() then
        coil.remove(self, i)
      end
    end
  end
  coil.current = nil
end


function coil:add(fn)
  local t = task.new(fn)
  table.insert(self, t)
  return t
end


function coil:remove(t)
  if type(t) == "number" then
    self[t] = self[#self]
    table.remove(self)
    return
  end
  for i, task in ipairs(self) do
    if task == t then
      coil.remove(self, i)
    end
  end
end


function coil.wait(x, _)
  x = _ or x
  local c = coil.current
  _assert(c, "coil.wait() called from outside a coroutine", 2)
  if type(x) == "number" then
    c.wait = (c.waitrem or 0) + x
    if c.wait <= 0 then
      c.waitrem = c.wait
      return
    else
      c.waitrem = nil
    end
  else
    c.waitrem = nil
    c.wait = x
  end
  coroutine.yield(true)
  -- Return args if wait was a callback object
  if type(x) == "table" then
    return unpack(x.args)
  end
  -- Return delta time if wait had no args
  if x == nil then
    return coil.deltatime
  end
end


local callback_mt = { 
  __call = function(t, ...)
    t.args = {...}
    t.ready = true
  end}

function coil.callback()
  local t = { ready = false }
  setmetatable(t, callback_mt)
  return t
end


function coil.group()
  local t = {}
  setmetatable(t, coil)
  return t
end



local bound = {
  update  = function(...) return coil.update(coil.tasks, ...) end,
  add     = function(...) return coil.add(coil.tasks, ...) end,
  remove  = function(...) return coil.remove(coil.tasks, ...) end,
}
setmetatable(bound, coil)

return bound
