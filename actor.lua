local Entity = require("base.entity")

local coil = require("lib.coil")
local lume = require("lib.lume")

local Projectile = require("projectile")

local Actor = Entity:extend()

function Actor:new()
    Actor.super.new(self)
    self.group = "Actor"
    self.hp = 10
    self.speed = 0
    self.shotrate = 1
    self.canshoot = true
    self.projspeed = 200
    self.projdmg = 20
end

function Actor:tryShoot()
    if self.canshoot then
        self.canshoot = false
        self.threads:add(function()
            coil.wait(self.shotrate)
            self.canshoot = true
        end)
        self:shoot()
    end
end

function Actor:shoot()
    local p = Projectile(10,self.projdmg)
    p.velocity = self.velocity:clone():normalize()*self.projspeed
    p.owner = self
    p.group = self.group
    p.x,p.y = self:middleX()-p.width/2,self:middleY()-p.height/2
    p.rotation = lume.random(0,math.pi*2)
    p.rotrate = 5
    self.parent:add(p)
end

function Actor:onHit(p)
    self.hp = self.hp - p.dmg
    if self.hp <= 0 then
        self:kill()
    end
end

function Actor:onKill()
    self:fragment(6,50)
end

return Actor
