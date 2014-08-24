local Object = require("lib.classic")
local statements = require("lib.statements")
local flux = require("lib.flux")
local lume = require("lib.lume")

local Group = require("base.group")
local Entity = require("base.entity")
local Rect = require("base.rect")

local Background = require("background")
local TextEntity = require("textentity")
local Game = require("game")
local stats = require("playerstats")

local MainMenu = Object:extend()
function MainMenu:new(debug)
    self.gui = Group()
    self.background = Background(love.graphics.getWidth(),love.graphics.getHeight(),25)
    self:createGui()
    self.fadeamt = 0
    self.tweens = flux.group()
    for _,key in pairs({"hp","movespeed","turnrate","shotrate","points"}) do
        stats[key] = 0
    end
end

function MainMenu:createGui()
    local title = TextEntity("Drempt")
    title:setFont("BPreplayBold.otf",80)
    title:setColor({50,50,50})
    title:middleX(Rect.fromScreen():middleX())
    title.y = 100

    local a1 = Entity()
    a1:setImage("aura.png",150)
    a1.rotation = lume.random(0,math.pi*2)
    a1.rotrate = -0.2
    a1:middleX(title:middleX())
    a1:middleY(title:middleY())

    local a2 = Entity()
    a2:setImage("aura.png",150)
    a2.rotation = lume.random(0,math.pi*2)
    a2.rotrate = 0.1
    a2:middleX(title:middleX()-90)
    a2:middleY(title:middleY()+20)

    local a3 = Entity()
    a3:setImage("aura.png",150)
    a3.rotation = lume.random(0,math.pi*2)
    a3.rotrate = 0.1
    a3:middleX(title:middleX()+90)
    a3:middleY(title:middleY()+20)

    local play = TextEntity("Play")
    play:setFont("BPreplayBold.otf",40)
    play:setColor({0,0,0})
    play.x,play.y = title.x,title:bottom()+100
    play.onClick = function()
        self.tweens:to(self,1,{fadeamt=255}):ease("quadin"):oncomplete(function()
                statements.switchState(require("game")())
            end)
    end
    play.nohover = false

    local freeplay = TextEntity("Free Play")
    freeplay:setFont("BPreplayBold.otf",40)
    freeplay:setColor({0,0,0})
    freeplay:right(title:right())
    freeplay.y = play.y
    freeplay.onClick = function()
        self.tweens:to(self,1,{fadeamt=255}):ease("quadin"):oncomplete(function()
                statements.switchState(require("freeplay")())
            end)
    end
    freeplay.nohover = false

    local instructions = TextEntity("Instructions")
    instructions:setFont("BPreplayBold.otf",40)
    instructions:setColor({0,0,0})
    instructions.y = play:bottom()+10
    instructions:middleX(title:middleX())
    instructions.onClick = function()
        statements.switchState(require("instructions")())
    end
    instructions.nohover = false

    local quit = TextEntity("Quit")
    quit:setFont("BPreplayBold.otf",40)
    quit:setColor({0,0,0})
    quit:middleX(title:middleX())
    quit.y = instructions:bottom()+10
    quit.onClick = function()
        love.event.quit()
    end
    quit.nohover = false

    local sndhint = TextEntity("Press m to toggle music, press n to toggle sound effects.")
    sndhint:setFont("BPreplayBold.otf",16)
    sndhint:setColor({50,50,50})
    sndhint:bottom(Rect.fromScreen():bottom()-5)
    sndhint:right(Rect.fromScreen():right()-5)

    self.gui:add(quit)
    self.gui:add(play)
    self.gui:add(a1)
    self.gui:add(a2)
    self.gui:add(a3)
    self.gui:add(title)
    self.gui:add(sndhint)
    self.gui:add(instructions)
    self.gui:add(freeplay)
end

function MainMenu:mousepressed(x,y,button)
    local elem = self.gui:collidePoint(x,y)
    if not elem then return end
    if elem.onClick then
        elem.onClick()
    end
end
function MainMenu:update(dt)
    self.tweens:update(dt)
    local elem = self.gui:collidePoint(love.mouse.getPosition())
    if elem and elem.hover then
        elem:hover()
    end
    self.gui:update(dt)
end
function MainMenu:draw()
    self.background:draw()
    self.gui:draw()
    if self.fadeamt ~= 0 then
        love.graphics.setColor(0,0,0,self.fadeamt)
        love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    end
end

return MainMenu
