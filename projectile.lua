local Entity = require("base.entity")

local Projectile = Entity:extend()
function Projectile:new(lifespan,dmg)
    Projectile.super.new(self)
    self:setImage("bullet.png",25)
    self.dmg = dmg
    self:setLifespan(lifespan)
end

function Projectile:onCollide(e)
    if self.owner ~= e then
        e:onHit(self)
        self:fragment(2)
        self:kill()
    end
end

return Projectile
