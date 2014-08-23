local Object = require("lib.classic")
local coil = require("lib.coil")
local lume = require("lib.lume")

local Group = require("base.group")
local MediaManager = require("base.mediamanager")
local Camera = require("base.camera")
local Rect = require("base.rect")

local Player = require("player")
local Enemy = require("enemy")
local Backgrounds = require("backgrounds")
local Gui = require("gui")

local Game = Object:extend()
function Game:new(debug)
    self.debug = debug
    self.entities = Group()
    self.gui = Gui()

    self.camera = Camera()

    self.bounds = Rect(0,0,2000,2000)
    self.background = Backgrounds.bubbles(self.bounds.width,self.bounds.height,25)

    self.player = Player(40,40)
    self.camera:focus(self.player)
    self.entities:add(self.player)

    self:spawnEnemy()

    self.points = 0

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
    print(e)
end

function Game:update(dt)
    self.entities:update(dt)
    self.camera:update(dt)
    self.gui:update(dt)
    self.threads:update(dt)
end

function Game:draw()
    self.camera:attach()
    self.background:draw()
    self.entities:draw()
    if self.debug then self.entities:drawDebug() end
    self.camera:detach()
    self.gui:draw()
end


return Game
