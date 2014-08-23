local Object = require("lib.classic")
local _ = require("lib.lume")

local Bubbles = Object:extend()

local function snap(x,l)
    return x-x%l
end

function Bubbles:new(w,h,gridsize)
    self.bubbles = {}
    self.w,self.h = w,h
    local gs = gridsize or 100
    self.gs = gs

    local bubblecount = w*h/(gs*gs) -- Approx 1 line per 100 px sq
    for i=1,bubblecount do
        local x,y = snap(_.random(w),gs),snap(_.random(h),gs)
        local r = _.random(5,40)
        local s = r*2
        table.insert(self.bubbles,{"fill",x,y,r,s})
    end

    local syslim = love.graphics.getSystemLimit("texturesize")
    if w < syslim and h < syslim then
        self.canvas = love.graphics.newCanvas(w,h)
        self:makeImage()
    end
end

function Bubbles:makeImage()
    local oc = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.setColor(love.graphics.getBackgroundColor())
    love.graphics.rectangle("fill",0,0,self.w,self.h)
    self:draw(true)
    love.graphics.setCanvas(oc)
end

function Bubbles:draw(nocanvas)
    love.graphics.setColor(255,255,255,100)
    if nocanvas or not self.canvas then
        for _,l in ipairs(self.bubbles) do
            love.graphics.circle(unpack(l))
        end
    else
        love.graphics.draw(self.canvas)
    end
end

return {bubbles=Bubbles}
