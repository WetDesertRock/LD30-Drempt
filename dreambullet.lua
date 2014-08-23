local Projectile = require("projectile")

local DreamBullet = Projectile:extend()

function DreamBullet:new(size,lifespan,dmg)
    DreamBullet.super.new(self,size,lifespan,dmg)
    self:setImage("dreambullet.png",size)
end

return DreamBullet
