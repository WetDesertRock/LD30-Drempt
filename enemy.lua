local lume = require("lib.lume")
local coil = require("lib.coil")

local Vector = require("base.vector")

local Actor = require("actor")
local Projectile = require("projectile")
local DreamBullet = require("dreambullet")
local TextEntity = require("textentity")

local Enemy = Actor:extend()

function Enemy:new(x,y)
    Enemy.super.new(self)
    self.group = "Enemy"
    self.x,self.y = x,y
    self.behaviors = {{self.avoidOthers,5},{self.seekPlayer,10}}
    self:setImage("enemy1.png",50)
    self.speed = 60
    self.playerdist = 100
    self.shootrate = 6
    self.shotrate = 3
    self.pointval = 0

    self.snd_onkill = "enemydie.ogg"

    self.threads:add(function()
        repeat
            coil.wait(lume.random(self.shotrate,self.shootrate))
            self:shoot()
        until nil
    end)
end

function Enemy:think()
    self.goal = Vector(0,0)
    for _,behavior in pairs(self.behaviors) do
        local v = behavior[1](self)
        self.goal = self.goal +v*behavior[2]
    end
    self.goal:normalize()
end

function Enemy:update(dt)
    self:think()
    Enemy.super.update(self,dt)
end

function Enemy:addBehavior(b,w)
    table.insert(self.behaviors,{b,w})
end

function Enemy:avoidOthers()
    local tx,ty = 0,0
    local sx,sy = self:middleX(),self:middleY()
    local c = 0
    for _,ent in pairs(self.parent.members) do
        if (ent:is(Enemy) or ent:is(Projectile)) and ent ~= self then
            tx = tx+ent:middleX()-sx
            ty = ty+ent:middleY()-sy
            c = c+1
        end
    end
    if c == 0 then return Vector(0,0) end
    tx,ty = tx/c,ty/c
    return Vector.fromComp(tx,ty):normalize()*-1
end
function Enemy:seekPlayer()
    local player = G.player
    local d = self.playerdist *self.playerdist
    if lume.distance(player.x,player.y,self.x,self.y,true) < d then
        return Vector(0,0)
    else
        return Vector.fromComp(player.x-self.x,player.y-self.y):normalize()
    end
end

function Enemy:onKill(p)
    Enemy.super.onKill(self,p)
    local ptval = self.pointval
    if p:is(DreamBullet) then
        ptval = -1*self.pointval
    end
    G.points = G.points+ptval

    local p = "+"
    local color = {102, 175, 83}
    if ptval < 0 then
        p = ""
        color = {207, 96, 96}
    end
    local pt = TextEntity(p..ptval)
    pt:setColor(color)
    pt:setFont("BPreplayBold.otf",16)
    pt.velocity.dir = -math.pi/2
    pt.velocity.mag = 40
    pt.x,pt.y = self:middleX(),self:middleY()
    pt:setLifespan(1)
    self.parent:add(pt)
end

return Enemy
