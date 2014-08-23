local Entity = require("base.entity")

local Actor = Entity:extend()

function Actor:new(state)
    Actor.super.new(self)
    self.state = state
end

return Actor
