local Group = require("base.group")
local Rect = require("base.rect")

local TextEntity = require("textentity")
local HealthBar = require("healthbar")

local gui = Group:extend()

function gui:new()
    gui.super.new(self)
    self.isinit = false
end
function gui:update(dt)
    gui.super.update(self,dt)
    if not self.isinit then
        local points = TextEntity("Points: ",G,"points")
        points.x = 10
        points.y = 10
        points:setFont("BPreplayBold.otf",16)
        points:setColor({0,0,0,150})
        self:add(points)

        local bar = HealthBar(G.player,"hp")
        bar.width,bar.height = 500,15
        bar:bottom(Rect.fromScreen():bottom()-5)
        bar:right(Rect.fromScreen():right()-5)
        self:add(bar)

        local wave = TextEntity("Dream Cycle: "..G.wave)
        wave:setFont("BPreplayBold.otf",16)
        wave:setColor({0,0,0,150})
        wave:bottom(Rect.fromScreen():bottom()-5)
        wave:left(5)
        self:add(wave)


        self.isinit = true
    end
end

return gui
