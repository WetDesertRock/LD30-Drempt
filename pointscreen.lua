local Object = require("lib.classic")
local statements = require("lib.statements")
local flux = require("lib.flux")
local lume = require("lib.lume")

local Group = require("base.group")
local Rect = require("base.rect")

local Background = require("background")
local TextEntity = require("textentity")
local stats = require("playerstats")

local PointMenu = Object:extend()
function PointMenu:new(debug)
    self.gui = Group()
    self.background = Background(love.graphics.getWidth(),love.graphics.getHeight(),25)
    self:createGui()
    self.fadeamt = 0
    self.tweens = flux.group()
    for _,key in pairs({"hp","movespeed","turnrate","shotrate"}) do
        stats[key] = 0
    end
end

function PointMenu:createGui()
    local title = TextEntity("Total Score")
    title:setFont("BPreplayBold.otf",60)
    title:setColor({50,50,50})
    title:bottom(Rect.fromScreen():bottom()-20)
    title.x = 50

    local upcount = 0
    for _,key in pairs({"hp","movespeed","turnrate","shotrate"}) do
        upcount = upcount + stats[key]
    end

    local total = TextEntity("Total: "..upcount*5 + stats.points)
    total:setFont("BPreplayBold.otf",30)
    total:setColor({0,0,0})
    total.x = title.x
    total:bottom(title:top()-60)

    local upgrades = TextEntity("Upgrades: "..upcount.."x5")
    upgrades:setFont("BPreplayBold.otf",30)
    upgrades:setColor({0,0,0})
    upgrades.x = title.x
    upgrades:bottom(total:top()-20)

    local points = TextEntity("Points: "..stats.points)
    points:setFont("BPreplayBold.otf",30)
    points:setColor({0,0,0})
    points.x = title.x
    points:bottom(upgrades:top()-20)

    local menu = TextEntity("Main Menu")
    menu:setFont("BPreplayBold.otf",30)
    menu:setColor({32, 100, 22})
    menu:right(Rect.fromScreen():right()-title.x)
    menu:bottom(title:bottom()-7)
    menu.nohover = false
    menu.onClick = function()
        self.tweens:to(self,1,{fadeamt=255}):ease("quadin"):oncomplete(function()
                statements.switchState(require("mainmenu")())
            end)
    end

    self.gui:add(title)
    self.gui:add(points)
    self.gui:add(upgrades)
    self.gui:add(total)
    self.gui:add(menu)
end

function PointMenu:mousepressed(x,y,button)
    local elem = self.gui:collidePoint(x,y)
    if not elem then return end
    if elem.onClick then
        elem.onClick()
    end
end
function PointMenu:update(dt)
    self.tweens:update(dt)
    local elem = self.gui:collidePoint(love.mouse.getPosition())
    if elem and elem.hover then
        elem:hover()
    end
    self.gui:update(dt)
end
function PointMenu:draw()
    self.background:draw()
    self.gui:draw()
    if self.fadeamt ~= 0 then
        love.graphics.setColor(0,0,0,self.fadeamt)
        love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    end
end

return PointMenu
