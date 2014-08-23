local Object = require("lib.classic")

local Group = require("base.group")
local MediaManager = require("base.mediamanager")
local Camera = require("base.camera")

local Player = require("player")
local Enemy = require("enemy")

local Game = Object:extend()
function Game:new(debug)
    self.debug = debug
    self.entities = Group()

    self.player = Player(40,40)
    self.entities:add(self.player)

    self.entities:add(Enemy(-200,-200))

    self.camera = Camera()
    self.camera:focus(self.player)
end

function Game:update(dt)
    self.entities:update(dt)
    self.camera:update(dt)
end

function Game:draw()
    self.camera:attach()
    self.entities:draw()
    if self.debug then self.entities:drawDebug() end
    self.camera:detach()
end


return Game
