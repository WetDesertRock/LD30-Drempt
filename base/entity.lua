-- Only the idea of this was stolen from rxi

local Rect = require("base.rect")
local Vector = require("base.vector")
local coil = require("lib.coil")
local flux = require("lib.flux")
local lume = require("lib.lume")
local Media = require("base.mediamanager")

local Entity = Rect:extend()

function Entity:new()
    Entity.super.new(self,0,0,0,0)

    self.dead = false
    self.collidable = true
    self.solid = true
    self.velocity = Vector(0,0)

    self.threads = coil.group()
    self.tweens = flux.group()

    self.rotation = nil -- Visual rotation
    self.rotrate = 0
    self.opacity = 255
end

function Entity:setImage(fp,width,height)
    self.image = Media:getImage(fp)

    self.sx,self.sy = 1,1
    if width then
        self.sx = width/self.image:getWidth()
        self.sy = self.sx
    end
    if height then
        self.sy = height/self.image:getHeight()
    end
    self.width,self.height = self.image:getWidth()*self.sx,self.image:getHeight()*self.sy
end

function Entity:setQuad(quad)
    self.quad = quad
    local x,y,w,h = quad:getViewport()
    self.width = w*(self.sx or 1)
    self.height = h*(self.sy or 1)
end

function Entity:setLifespan(lifespan,fade)
    self.threads:add(function()
        coil.wait(lifespan)
        if not fade then
            self:kill()
        else
            self.tweens:to(self,0.5,{opacity=0}):oncomplete(function() self:kill() end)
        end
    end)
end

function Entity:update(td)
    local vec = Vector.fromComp(self.x,self.y) + self.velocity*td
    self.x,self.y = vec:x(),vec:y()

    if self.rotation then
        self.rotation = self.rotation + td*self.rotrate
    end

    self.threads:update(td)
    self.tweens:update(td)
end

function Entity:draw()
    if self.color then
        love.graphics.setColor(self.color)
    elseif self.opacity then
        love.graphics.setColor(255,255,255,self.opacity)
    end
    if self.image then
        local x,y = self.x+self.width/2,self.y+self.height/2

        local rot = self.rotation
        if not self.rotation then
            rot = self.velocity.dir--+math.pi/2
        end

        if self.quad then
            local qx,qy,qw,qh = self.quad:getViewport()
            love.graphics.draw(self.image,self.quad, x,y, rot, self.sx,self.sy ,qw/2,qh/2)
        else
            local ox,oy = self.image:getWidth()/2,self.image:getHeight()/2
            love.graphics.draw(self.image, x,y, rot, self.sx,self.sy ,ox,oy)
        end
    end
end

function Entity:drawDebug()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle("line",self.x,self.y,self.width,self.height)

    love.graphics.setColor(100,100,255)
    love.graphics.line(self.x,self.y,self.velocity:x()+self.x,self.velocity:y()+self.y)
end

function Entity:fragment(iterations,skipchance)
    local rects = {{x=self.x,y=self.y,w=self.width,h=self.height}}
    local nrects
    skipchance = skipchance or 0
    for i=0,iterations do
        nrects = {}
        for _,rect in ipairs(rects) do
            if lume.random(0,100) < skipchance then
                table.insert(nrects,rect)
            else
                local df = lume.randomchoice({2, 3, 4})
                local a,b
                if lume.randomchoice({true, false}) then
                    a = {x=rect.x,y=rect.y,w=rect.w/df,h=rect.h}
                    b = {x=rect.x+rect.w/df,y=rect.y,w=rect.w-rect.w/df,h=rect.h}
                else
                    a = {x=rect.x,y=rect.y,w=rect.w,h=rect.h/df}
                    b = {x=rect.x,y=rect.y+rect.h/df,w=rect.w,h=rect.h-rect.h/df}
                end
                table.insert(nrects,a)
                table.insert(nrects,b)
            end
        end
        rects = {}
        for _,v in ipairs(nrects) do
            table.insert(rects,v)
        end
    end

    local centerV = Vector(self:middleX(),self:middleY())

    for _,rect in pairs(rects) do
        local ent = Entity(true)
        ent.x = rect.x
        ent.y = rect.y
        ent.width = rect.w
        ent.height = rect.h
        local quad = love.graphics.newQuad(
                                            (rect.x-self.x)/self.sx,
                                            (rect.y-self.y)/self.sy,
                                            rect.w/self.sx,
                                            rect.h/self.sy,
                                            self.image:getWidth(),
                                            self.image:getHeight()
                                            )
        ent.sx,ent.sy = self.sx,self.sy
        ent.image = self.image
        ent:setQuad(quad)
        ent.collidable = false
        local v = Vector.fromComp(ent:middleX(),ent:middleY()) - centerV
        v:normalize()
        v = v * lume.random(50,70)--60
        ent.velocity = v+self.velocity
        ent.autorotate = false
        ent.rotrate = lume.random(0.2,math.pi*2)
        ent.rotation = lume.random(0,math.pi*2)
        ent:setLifespan(lume.random(2.8,3.8),true)

        self.parent:add(ent)
    end
end

function Entity:kill(...)
    self.dead = true
    self:onKill(...)
end

function Entity:onCollide(e)
end

function Entity:onHit(e)
end

function Entity:onKill(...)
end

function Entity:__tostring()
  return lume.format("Entity({x}, {y})", self)
end

return Entity
