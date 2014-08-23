local Object = require("lib.classic")
local coil = require("lib.coil")
local flux = require("lib.flux")
local lume = require("lib.lume")
local statements = require("lib.statements")

local Group = require("base.group")
local MediaManager = require("base.mediamanager")
local Camera = require("base.camera")
local Rect = require("base.rect")

local Player = require("player")
local Enemy = require("enemy")
local Background = require("background")
local Gui = require("gui")

local Game = Object:extend()
function Game:new(debug)
    self.debug = debug
    self.entities = Group()
    self.gui = Gui()

    self.camera = Camera()

    self.bounds = Rect(0,0,2000,2000)
    self.background = Background(self.bounds.width,self.bounds.height,25)

    self.player = Player(1000,1000)
    self.camera:focus(self.player)
    self.entities:add(self.player)

    self:spawnEnemy()

    self.points = 0

    self.fadeamt = 0

    self.tweens = flux.group()
    self.threads = coil.group()
    self.threads:add(function()
            repeat
                coil.wait(1.5)
                self:spawnEnemy()
            until nil
        end
        )
end

function Game:spawnEnemy()
    local cls = lume.randomchoice(require("enemies"))
    local x = lume.random(-200,200)+self.player.x
    local y = lume.random(-200,200)+self.player.y
    local e = cls(x,y)
    self.camera:reject(e)
    self.entities:add(e)
end

function Game:update(dt)
    self.threads:update(dt)
    self.tweens:update(dt)
    self.entities:update(dt)
    self.camera:update(dt)
    self.gui:update(dt)
end

function Game:draw()
    self.camera:attach()
    self.background:draw()
    self.entities:draw()
    if self.debug then self.entities:drawDebug() end
    self.camera:detach()
    self.gui:draw()
    if self.fadeamt ~= 0 then
        love.graphics.setColor(0,0,0,self.fadeamt)
        love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    end
end

function Game:die()
    self.tweens:to(self,1,{fadeamt=255}):ease("quadin"):oncomplete(function()
            statements.switchState(require("mainmenu")())
        end)
end

return Game
