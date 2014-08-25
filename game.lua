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
local stats = require("playerstats")
local TextEntity = require("textentity")

local Game = Object:extend()
local WaveTexts = {
    "This is the first Dream Cycle of five. Throw an Observance at the Manifestations with a white aura surrounding them.\nAuras will fade with each progressive Dream Cycle, so learn the behavioral differences between the two Manifestations!",
    "The auras are starting to fade, you should keep learning the differences between the different manifestations.",
    "",
    "",
    "This is the last Dream Cycle, make it count!"
}
local WaveAlphas = {100,70,40,20,0}
-- local SpawnRates = {1.5,1.2,0.9,0.8,0.8}
local SpawnRates = {1.6,1.6,1.6,1.6,1.6,1.6}
function Game:new(debug,skiptext)
    self.debug = debug
    self.entities = Group()
    self.gui = Gui()

    self.camera = Camera()

    self.bounds = Rect(0,0,2000,2000)
    self.background = Background(self.bounds.width,self.bounds.height,25)

    self.player = Player(1000,1000)
    self.player.turnrate = self.player.turnrate+(stats.turnrate/2)
    self.player.speed = self.player.speed+(stats.movespeed*10)
    self.player.shotrate = self.player.shotrate-(stats.shotrate/4)
    self.player.hp = self.player.hp+(stats.hp*10)
    self.player.hp_max = self.player.hp

    self.camera:focus(self.player)
    self.entities:add(self.player)

    stats.wave = stats.wave + 1
    self.wave = stats.wave
    self.points = stats.points
    self.dreamalpha = WaveAlphas[self.wave]
    self.dreamkills = 0
    self.dreamcaptures = 0
    self.realkills = 0
    self.realcaptures = 0

    self.fadeamt = 0

    if WaveTexts[self.wave] ~= "" and not skiptext then
        local helptext = TextEntity(WaveTexts[self.wave])
        helptext:setFont("BPreplayBold.otf",20)
        helptext:setColor({0,0,0})
        helptext.width = love.graphics.getWidth()*0.75
        helptext:middleX(Rect.fromScreen():middleX())
        helptext:middleY(Rect.fromScreen():middleY())
        helptext.printf = true
        helptext:setLifespan(15,true)
        self.gui:add(helptext)
    end

    self.timer = 0


    self.tweens = flux.group()
    self.threads = coil.group()
    self.threads:add(function()
            repeat
                coil.wait(SpawnRates[self.wave])
                self:spawnEnemy()
            until nil
        end
        )
end

function Game:enter()
    love.mouse.setGrabbed(true)
    G = self
end
function Game:leave()
    love.mouse.setGrabbed(false)
    -- G = nil
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
    self.timer = self.timer+dt
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
    self.tweens:to(self,4,{fadeamt=255}):ease("quadin"):oncomplete(function()
            if self.wave == 5 then
                statements.switchState(require("pointscreen")())
            else
                statements.switchState(require("shopmenu")())
            end
        end)
    stats.points = math.max(self.points,0)

    local report = {
        leveltime = self.timer,
        dreamkills = self.dreamkills,
        dreamcaptures = self.dreamcaptures,
        realkills = self.realkills,
        realcaptures = self.realcaptures
    }
    require("statreporter").report("levelend",report,true)
end

return Game
