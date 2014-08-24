local Entity = require("base.entity")
local Vector = require("base.vector")
local Media = require("base.mediamanager")

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
    self.projdmg = 10
    self.projsize = 15
    self.goal = Vector(0,0)
    self.turnrate = 5
end

function Actor:update(dt)
    cvel = self.velocity:clone():normalize()
    self.velocity = cvel + (self.goal-cvel) * self.turnrate * dt
    self.velocity = self.velocity:normalize()*self.speed
    Actor.super.update(self,dt)
    self:clamp(G.bounds)
end

function Actor:tryShoot(cls)
    if self.canshoot then
        self.canshoot = false
        self.threads:add(function()
            coil.wait(self.shotrate)
            self.canshoot = true
        end)
        self:shoot(cls)
    end
end

function Actor:shoot(cls)
    cls = cls or Projectile
    local p = cls(self.projsize,10,self.projdmg)
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
        self:kill(p)
        if self.snd_onkill then
            self:playSound(self.snd_onkill)
        end
    else
        if self.snd_onhit then
            self:playSound(self.snd_onhit)
        end
    end
end

function Actor:playSound(s)
    local snd = Media:playSound(s)
    snd:setRelative(false)
    snd:setPosition(self.x, self.y, 0)
    snd:setVelocity(self.velocity:x(),self.velocity:y(),0)
    snd:setAttenuationDistances(20,300)
end

function Actor:onKill(...)
    self:fragment(8,50)
end

return Actor
