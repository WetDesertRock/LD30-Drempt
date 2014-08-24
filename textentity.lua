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
    if self.prefix then
        love.graphics.print(self.prefix..self.target[self.key],self.x+self.offx,self.y+self.offy)
    else
        love.graphics.print(self.text,self.x+self.offx,self.y+self.offy)
    end
    self.offx,self.offy = 0,0
end
return TextEntity
