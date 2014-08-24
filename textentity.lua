local Entity = require("base.entity")
local Media = require("base.mediamanager")

local TextEntity = Entity:extend()
function TextEntity:new(prefix,target,key)
    TextEntity.super.new(self)
    if target then
        self.prefix = prefix
        self.target = target
        self.key = key
    else
        self.text = prefix
    end
    self.offx,self.offy = 0,0
    self.nohover = true
    self.collidable = false
    self.printf = false
    self.align = "center"
end
function TextEntity:setFont(fp,s)
    self.font = Media:getFont(fp,s)
    local t = self.text or self.prefix
    self.width = self.font:getWidth(t)
    self.height = self.font:getHeight()
end
function TextEntity:setColor(color)
    self.color = color
end
function TextEntity:hover()
    if not self.nohover then
        self.offx,self.offy = 3,3
    end
end
function TextEntity:draw()
    if self.color then
        love.graphics.setColor(self.color)
    end
    if self.font then
        love.graphics.setFont(self.font)
    end
    local t = self.text
    if self.prefix then
        t = self.prefix..self.target[self.key]
    end

    if self.printf then
        love.graphics.printf(t,self.x+self.offx,self.y+self.offy,self.width,self.align)
    else
        love.graphics.print(t,self.x+self.offx,self.y+self.offy)
    end

    self.offx,self.offy = 0,0
end
return TextEntity
