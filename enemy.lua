local lume = require("lib.lume")

local Vector = require("base.vector")

local Actor = require("actor")
local Projectile = require("projectile")

local Enemy = Actor:extend()

function Enemy:new(x,y)
    Enemy.super.new(self)
    self.x,self.y = x,y
    self.goal = Vector(0,0)
    self.turnrate = 20
    self.behaviors = {{self.avoidOthers,5},{self.seekPlayer,10}}
    self:setImage("bullet.png",50)
    self.turnrate = 5
    self.speed = 60
    self.playerdist = 100
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

    cvel = self.velocity:clone():normalize()

    self.velocity = cvel + (self.goal-cvel) * self.turnrate * dt
    -- self.velocity = self.goal
    self.velocity = self.velocity:normalize()*self.speed

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

return Enemy
