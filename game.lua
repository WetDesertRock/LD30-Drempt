local Object = require("lib.classic")

local Group = require("base.group")
local MediaManager = require("base.mediamanager")
local Camera = require("base.camera")
local Rect = require("base.rect")

local Player = require("player")
local Enemy = require("enemy")
local Backgrounds = require("backgrounds")

local Game = Object:extend()
function Game:new(debug)
    self.debug = debug
    self.entities = Group()

    self.player = Player(40,40)
    self.entities:add(self.player)

    self.entities:add(Enemy(200,200))
    self.entities:add(Enemy(250,200))
    self.entities:add(Enemy(200,250))
    self.entities:add(Enemy(300,200))
    self.entities:add(Enemy(200,300))
    self.entities:add(Enemy(350,200))
    self.entities:add(Enemy(200,350))

    self.camera = Camera()
    self.camera:focus(self.player)

    self.bounds = Rect(0,0,2000,2000)
    self.background = Backgrounds.bubbles(self.bounds.width,self.bounds.height,25)
end

function Game:update(dt)
    self.entities:update(dt)
    self.camera:update(dt)
end

function Game:draw()
    self.camera:attach()
    self.background:draw()
    self.entities:draw()
    if self.debug then self.entities:drawDebug() end
    self.camera:detach()
end


return Game
