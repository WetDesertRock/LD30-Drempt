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

local Instructions = Object:extend()
function Instructions:new(debug)
    self.gui = Group()
    self.background = Background(love.graphics.getWidth(),love.graphics.getHeight(),25)
    self.tweens = flux.group()
    self:createGui()
    self.fadeamt = 0
    for _,key in pairs({"hp","movespeed","turnrate","shotrate","points"}) do
        stats[key] = 0
    end
end

local instructions = [[
    Drempt is a game about when the external world connects with your dream world that takes place throughout five dream cycles.
    There are two different kinds of manifestations: The Visitors are external manifestations in your dreams, and the Glimmers are manifestations of the dream itself. As the primary observer in your dream, you need to figure out what is a Visitor and what is a Glimmer.
    Your goal is to discern between these two manifestations by shooting them with their specific bullet. Left click will shoot bullets made for the Visitors, right click will shoot bullets made for the Glimmers. If you match it up right you will gain points, if you don't you will lose points.
    You can discern between the two manifestations by the presence of a glimmer, or the differences in the behaviors. Glimmers will have an aura around them that will fade with each new Dream Cycle, eventually they won't exist at all. Because of this its important to learn the differences in behaviors. Visitors are more quick to react, turn faster and move faster while Glimmers are more smooth graceful.
    At the end of each Dream Cycle you can purchese upgrades to help you out later on. Remember that your points carry over into the next cycle so you could lose them if you don't spend them. Your final score is based off of how many points you have at the end of the final cycle.
    To get used to these different behaviors, you can try out the freeplay mode.
]]

function Instructions:createGui()
    local title = TextEntity("Instructions")
    title:setFont("BPreplayBold.otf",60)
    title:setColor({50,50,50})
    title:middleX(Rect.fromScreen():middleX())
    title.y = 40

    local back = TextEntity("Back")
    back:setFont("BPreplayBold.otf",30)
    back:setColor({0,0,0})
    back:right(Rect.fromScreen():right()-25)
    back:bottom(Rect.fromScreen():bottom()-10)
    back.onClick = function()
        self.tweens:to(self,1,{fadeamt=255}):ease("quadin"):oncomplete(function()
                statements.switchState(require("mainmenu")())
            end)
    end
    back.nohover = false


    local instructions = TextEntity(instructions)
    instructions:setFont("BPreplayBold.otf",16)
    instructions:setColor({0,0,0})
    instructions.x = 100
    instructions.y = title:bottom()+20
    instructions.width = love.graphics.getWidth()-200
    instructions.align = "left"
    instructions.printf = true

    self.gui:add(title)
    self.gui:add(back)
    self.gui:add(instructions)
end

function Instructions:mousepressed(x,y,button)
    local elem = self.gui:collidePoint(x,y)
    if not elem then return end
    if elem.onClick then
        elem.onClick()
    end
end
function Instructions:update(dt)
    self.tweens:update(dt)
    local elem = self.gui:collidePoint(love.mouse.getPosition())
    if elem and elem.hover then
        elem:hover()
    end
    self.gui:update(dt)
end
function Instructions:draw()
    self.background:draw()
    self.gui:draw()
    if self.fadeamt ~= 0 then
        love.graphics.setColor(0,0,0,self.fadeamt)
        love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    end
end

return Instructions
