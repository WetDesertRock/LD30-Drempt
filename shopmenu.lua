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

local ShopMenu = Object:extend()
function ShopMenu:new()
    self.gui = Group()
    self.background = Background(love.graphics.getWidth(),love.graphics.getHeight(),25)
    self:createGui()
    self.fadeamt = 0
    self.tweens = flux.group()
end

function ShopMenu:createGui()
    local title = TextEntity("Bolster")
    title:setFont("BPreplayBold.otf",60)
    title:setColor({50,50,50})
    title:bottom(Rect.fromScreen():bottom()-20)
    title.x = 50

    local points = TextEntity("Remaining points: ",stats,"points")
    points:setFont("BPreplayBold.otf",30)
    points:setColor({0,0,0})
    points.x = title.x
    points:bottom(title:top()-60)


    local play = TextEntity("Next Dream Cycle")
    play:setFont("BPreplayBold.otf",30)
    play:setColor({32, 100, 22})
    play:right(Rect.fromScreen():right()-title.x)
    play:bottom(title:bottom()-7)
    play.onClick = function()
        self.tweens:to(self,1,{fadeamt=255}):ease("quadin"):oncomplete(function()
                statements.switchState(require("game")())
            end)
    end
    play.nohover = false
    self.gui:add(title)
    self.gui:add(play)
    self.gui:add(points)

    function makeBuyable(key,y)
        local count,name,cost
        function fmtname(key)
            count = stats[key]
            name = stats["n_"..key]
            cost = math.floor(stats["c_"..key]*(count+1))
            return "("..count..") "..name..": "..cost
        end
        function buy(key)
            count = stats[key]
            cost = math.floor(stats["c_"..key]*(count+1))
            if cost <= stats.points then
                stats.points = stats.points - cost
                stats[key] = count+1
            end
        end
        local buyable = TextEntity(fmtname(key))
        buyable:setFont("BPreplayBold.otf",20)
        buyable:bottom(y-30)
        buyable.x = title.x
        buyable.nohover = false
        buyable.onClick = function()
            buy(key)
            makeBuyable(key,y)
            buyable:kill()
        end
        self.gui:add(buyable)
        return buyable
    end

    local y = points:top()-20
    for k,v in ipairs({"hp","movespeed","turnrate","shotrate"}) do
        local e = makeBuyable(v,y)
        y = e:top()
    end
end

function ShopMenu:mousepressed(x,y,button)
    local elem = self.gui:collidePoint(x,y)
    if not elem then return end
    if elem.onClick then
        elem.onClick()
    end
end
function ShopMenu:update(dt)
    self.tweens:update(dt)
    local elem = self.gui:collidePoint(love.mouse.getPosition())
    if elem and elem.hover then
        elem:hover()
    end
    self.gui:update(dt)
end
function ShopMenu:draw()
    self.background:draw()
    self.gui:draw()
    if self.fadeamt ~= 0 then
        love.graphics.setColor(0,0,0,self.fadeamt)
        love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    end
end

return ShopMenu
