local Vector = require("base.vector")
local Key = require("base.keybinds")

local Actor = require("actor")
local Projectile = require("projectile")
local DreamBullet = require("dreambullet")

local Player = Actor:extend()

function Player:new(x,y)
    Player.super.new(self)
    self.group = "Player"
    self.x,self.y = x,y
    self.mag = 0
    self:setImage("player.png",40)
    self.speed = 120
    self.shotrate = 0.5
    self.hp = 100
    self.turnrate = 6
    self.projsize = 25
    self.snd_onkill = "playerdie.ogg"
    self.snd_onhit = "playerhit.ogg"
end

function Player:update(dt)
    Player.super.update(self,dt)

    mx,my = G.camera:getMousePosition()
    self.goal = Vector.fromComp(mx-self:middleX(),my-self:middleY()):normalize()
    -- self.velocity = mvec*self.speed

    if Key.isDown("shootA") then
        self:tryShoot(Projectile)
    end
    if Key.isDown("shootB") then
        self:tryShoot(DreamBullet)
    end

    love.audio.setPosition(self.x,self.y,0)
    love.audio.setVelocity(self.velocity:x(),self.velocity:y(),0)
end

function Player:arrowKeyControl()
    local mx,my = 0,0

    if Key.isDown("up") then
        my = my-1
    end
    if Key.isDown("down") then
        my = my+1
    end
    if Key.isDown("left") then
        mx = mx-1
    end
    if Key.isDown("right") then
        mx = mx+1
    end

    if mx ~= 0 or my ~= 0 then
        self.velocity = Vector.fromComp(mx,my)
        self.velocity.mag = self.speed
    end
    if mx == 0 and my == 0 then
        self.velocity.mag = 0
    end
end

function Player:onKill(...)
    Player.super.onKill(self,...)
    G:die()
end


return Player
