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
end
function TextEntity:setFont(fp,s)
    self.font = Media:getFont(fp,s)
end
function TextEntity:setColor(color)
    self.color = color
end
function TextEntity:draw()
    if self.color then
        love.graphics.setColor(self.color)
    end
    if self.font then
        love.graphics.setFont(self.font)
    end
    if self.prefix then
        love.graphics.print(self.prefix..self.target[self.key],self.x,self.y)
    else
        love.graphics.print(self.text,self.x,self.y)
    end
end
return TextEntity
