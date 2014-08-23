local Vector = require("base.vector")
local Key = require("base.keybinds")

local Actor = require("actor")

local Player = Actor:extend()

function Player:new(x,y)
    Player.super.new(self)
    self.x,self.y = x,y
    self.mag = 0
    self:setImage("player.png",50)
    self.speed = 70
    self.shotrate = 0.5
end

function Player:update(dt)
    Player.super.update(self,dt)
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

    if Key.isDown("shoot") then
        self:tryShoot()
    end
end


return Player
