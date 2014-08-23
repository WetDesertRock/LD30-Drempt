local Group = require("base.group")

local TextEntity = require("textentity")

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
        points:setColor({0,0,0})
        self:add(points)
        self.isinit = true
    end
end

return gui
