local Entity = require("base.entity")

local HealthBar = Entity:extend()
function HealthBar:new(target,key)
    HealthBar.super.new(self)
    self.target,self.key = target,key
    self.collidable = false
    self.dispamt = 1
    self.amt = 1
end
function HealthBar:update(dt)
    HealthBar.super.update(self,dt)
    local amt = self.target[self.key]/self.target[self.key.."_max"]
    if amt ~= self.amt then
        self.amt = amt
        self.tweens:to(self,0.1,{dispamt=amt})
    end
end

function HealthBar:draw()
    love.graphics.setColor(117, 127, 169, 200)
    love.graphics.rectangle("fill",self.x,self.y,self.width*self.dispamt,self.height)
    love.graphics.setColor(0,0,0, 150)
    love.graphics.rectangle("line",self.x,self.y,self.width,self.height)
end
return HealthBar
