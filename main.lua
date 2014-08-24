local loveerr = love.errhand
local statements = require("lib.statements")
local flux = require("lib.flux")
local Media = require('base.mediamanager')

DEBUG = true
REPORTSTATS = true

local statreporter = require("statreporter")

local GlobalState = statements.new()

function GlobalState:init()
    self.music = Media:playSound("music.ogg")
    self.music:setVolume(0)
    self.music:setLooping(true)
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

function GlobalState:errhand(msg)
    local report = {
        msg = tostring(msg),
        trace = debug.traceback(),
    }
    statreporter.report("error",report,false)
    loveerr(msg)
end

function GlobalState:keypressed(key,isdown)
    if key == "m" then
        local g = 0
        if self.musicvol == 0 then g = 1 end
        flux.to(self,1,{musicvol=g})
    end
    if key == "n" then
        if Media.defaultvolume == 0 then
            Media.defaultvolume = 1
        else
            Media.defaultvolume = 0
        end
    end
    if key == "s" and DEBUG and G then
        G:die()
    end
end


function love.load()
    love.graphics.setBackgroundColor(131, 130, 124)
    math.randomseed(os.clock())

    G = nil

    statreporter.init()

    resw,resh = love.window.getDesktopDimensions( display )
    local report = {
        res = {resw,resh},
        os = love.system.getOS( )
    }
    statreporter.report("initial",report,false)

    GlobalState:init()

    statements.setGlobalState(GlobalState)
    statements.switchState(require('pointscreen')())

    love.audio.setDistanceModel("linear clamped")
end
