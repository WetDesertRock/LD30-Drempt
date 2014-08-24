local statements = require("lib.statements")
local flux = require("lib.flux")
local Media = require('base.mediamanager')

DEBUG = true

local GlobalState = statements.new()

function GlobalState:init()
    self.music = Media:playSound("music.ogg")
    self.music:setVolume(0)
    self.music:setLooping(true)
    self.music:pause()
    self.musicvol = 0
    flux.to(self,4,{musicvol=1})
end

function GlobalState:update(dt)
    if DEBUG then
        require("lib.lovebird").update(dt)
    end
    flux.update(dt)
    self.music:setVolume(self.musicvol)
end

function love.load()
    love.graphics.setBackgroundColor(131, 130, 124)
    math.randomseed(os.clock())

    G = nil

    GlobalState:init()

    statements.setGlobalState(GlobalState)
    statements.switchState(require('pointscreen')())

    love.audio.setDistanceModel("linear clamped")
end

function love.keypressed(key,isrepeat)
end

function love.keypressed(k)
end


function love.keyreleased(k)
end
