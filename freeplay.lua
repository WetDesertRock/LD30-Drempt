local statements = require("lib.statements")

local Rect = require("base.rect")

local TextEntity = require("textentity")
local Game = require("Game")
local stats = require("playerstats")
local Enemy = require("enemy")
local Projectile = require("projectile")

local FreePlay = Game:extend()
local _helptext = [[
Welcome to the freeplay mode. Here you can observe the behaviors of the manifestations without the possibility of fading off into the next Dream Cycle.
Press the enter or escape key when you are ready to leave.
]]
function FreePlay:new(debug)
    FreePlay.super.new(self,debug,true)

    self.player.hp = 100
    self.player.hp_max = 100
    self.player.freeplay = true

    self.dreamalpha = 100

    local helptext = TextEntity(_helptext)
    helptext:setFont("BPreplayBold.otf",20)
    helptext:setColor({0,0,0})
    helptext.width = love.graphics.getWidth()*0.75
    helptext:middleX(Rect.fromScreen():middleX())
    helptext:middleY(Rect.fromScreen():middleY())
    helptext.printf = true
    helptext:setLifespan(15,true)
    self.gui:add(helptext)
end

function FreePlay:spawnEnemy()
    local c = 0
    for _,m in pairs(self.entities.members) do
        if m:is(Enemy) then
            c = c+1
        end
    end
    if c < 10 then
        FreePlay.super.spawnEnemy(self)
    end
end

function FreePlay:keypressed(key,isrepeat)
    if key == "return" or key == "escape" or key == "kpenter" then
        self:die()
    end
end

function FreePlay:die()
    self.tweens:to(self,4,{fadeamt=255}):ease("quadin"):oncomplete(function()
            statements.switchState(require("mainmenu")())
        end)

    local p = Projectile(10,10,200)
    for _,m in pairs(self.entities.members) do
        if m:is(Enemy) then
            m:onHit(p)
        end
    end

    local report = {
        leveltime = self.timer
    }
    require("statreporter").report("freeplay",report,true)
end

return FreePlay
