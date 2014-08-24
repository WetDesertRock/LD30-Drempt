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
    title:setFont("BPreplayBold.otf",70)
    title:setColor({50,50,50})
    title:middleX(Rect.fromScreen():middleX())
    title.y = 100

    local points = TextEntity("Points: "..stats.points)
    points:setFont("BPreplayBold.otf",30)
    points:setColor({0,0,0})
    points:middleX(title:middleX())
    points.y = title:bottom()+100

    local upcount = 0
    for _,key in pairs({"hp","movespeed","turnrate","shotrate"}) do
        upcount = upcount + stats[key]
    end

    local upgrades = TextEntity("Upgrades: "..upcount.."x5")
    upgrades:setFont("BPreplayBold.otf",30)
    upgrades:setColor({0,0,0})
    upgrades.x = points.x
    upgrades.y = points:bottom()+10

    local total = TextEntity("Total: "..upcount*5 + stats.points)
    total:setFont("BPreplayBold.otf",30)
    total:setColor({0,0,0})
    total.x = points.x
    total.y = upgrades:bottom()+20

    local menu = TextEntity("Main Menu")
    menu:setFont("BPreplayBold.otf",40)
    menu:setColor({0,0,0})
    menu:middleX(title:middleX())
    menu.y = Rect.fromScreen():bottom()-70
    menus.nohover = false
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
