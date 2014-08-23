local Entity = require("base.entity")

local Projectile = Entity:extend()
function Projectile:new(size,lifespan,dmg)
    Projectile.super.new(self)
    self:setImage("bullet.png",size)
    self.dmg = dmg
    self:setLifespan(lifespan)
end

function Projectile:onCollide(e)
    if self.group ~= e.group then
        e:onHit(self)
        self:fragment(2)
        self:kill()
    end
end

return Projectile
