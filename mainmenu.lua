local Object = require("lib.classic")
local statements = require("lib.statements")
local flux = require("lib.flux")

local Group = require("base.group")

local Background = require("background")
local TextEntity = require("textentity")
local Game = require("game")

local MainMenu = Object:extend()
function MainMenu:new(debug)
    self.gui = Group()
    self.background = Background(love.graphics.getWidth(),love.graphics.getHeight(),25)
    self:createGui()
    self.fadeamt = 0
    self.tweens = flux.group()
end

function MainMenu:createGui()
    local title = TextEntity("Drempt")
    title:setFont("BPreplayBold.otf",80)
    title:setColor({50,50,50})
    title.x,title.y = 250,50
    self.gui:add(title)


    local play = TextEntity("Play")
    play:setFont("BPreplayBold.otf",40)
    play:setColor({0,0,0})
    play.x,play.y = 100,100
    play.onClick = function()
        self.tweens:to(self,1,{fadeamt=255}):ease("quadin"):oncomplete(function()
                G = Game()
                statements.switchState(G)
            end)
    end
    play.nohover = false
    self.gui:add(play)


    local quit = TextEntity("Quit")
    quit:setFont("BPreplayBold.otf",40)
    quit:setColor({0,0,0})
    quit.x,quit.y = play:right(),play:bottom()
    quit.onClick = function()
        love.event.quit()
    end
    quit.nohover = false
    self.gui:add(quit)
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
    if elem then
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
