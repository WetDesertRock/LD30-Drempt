local Object = require("lib.classic")

local Group = require("base.group")
local MediaManager = require("base.mediamanager")

local Player = require("player")

local Game = Object:extend()
function Game:new(debug)
    self.debug = debug
    self.entities = Group()
    self.player = Player(40,40)
    self.entities:add(self.player)
end

function Game:update(dt)
    self.entities:update(dt)
end

function Game:draw()
    self.entities:draw()
    if self.debug then self.entities:drawDebug() end
end


return Game
