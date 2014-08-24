local Enemy = require("enemy")

local DreamEnemy = Enemy:extend()
function DreamEnemy:new(x,y)
    DreamEnemy.super.new(self,x,y)
    self.turnrate = 2
    self.speed = 50
    self.pointval = -10
    self.behaviors = {{self.avoidOthers,5},{self.seekPlayer,5}}
end

local RealEnemy = Enemy:extend()
function RealEnemy:new(x,y)
    RealEnemy.super.new(self,x,y)
    self.turnrate = 10
    self.pointval = 10
end

return {DreamEnemy,RealEnemy}
