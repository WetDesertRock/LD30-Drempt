local Object = require("lib.classic")
local lume = require("lib.lume")
local Vector = Object:extend()

function Vector:new(dir,mag)
    if type(dir) == "table" then
        return Vector.fromComp(dir.x,dir.y)
    end
    self.dir = dir
    self.mag = mag
end

function Vector.fromComp(x,y)
    return Vector(math.atan2(y,x),lume.distance(0,0,x,y))
end

function Vector:x()
    return math.cos(self.dir)*self.mag
end
function Vector:y()
    return math.sin(self.dir)*self.mag
end

function Vector:__add(b)
    if type(b) == "number" then
        return Vector.fromComp(self:x()+b,self:y()+b)
    else
        return Vector.fromComp(self:x() + b:x(), self:y() + b:y())
    end
end
function Vector:__sub(b)
    if type(b) == "number" then
        return Vector.fromComp(self:x()-b,self:y()-b)
    else
        return Vector.fromComp(self:x()-b:x(), self:y()-b:y())
    end
end
function Vector:__mul(b)
    if type(b) == "number" then
        return Vector.fromComp(self:x()*b,self:y()*b)
    else
        return Vector.fromComp(self:x()*b:x(), self:y()*b:y())
    end
end
function Vector:__div(b)
    if type(b) == "number" then
        return Vector.fromComp(self:x()/b,self:y()/b)
    else
        return Vector.fromComp(self:x()/b:x(), self:y()/b:y())
    end
end

function Vector:__eq(b)
    return self.dir == b.dir and self.mag == b.mag
end

function Vector:__tostring()
    return "Vector("..self.dir..","..self.mag..")"
end

function Vector:clone()
    return Vector(self.dir,self.mag)
end

function Vector:distance(b)
    return (b-self).mag
end

function Vector:normalize()
    self.mag = 1
    return self
end
function Vector:rotate(phi)
    self.dir = phi
    return self
end

function Vector:perpendicular()
    return Vector.fromComp(-self:y(), self:x())
end

function Vector:cross(other)
    return self:x() * other:y() - self:y() * other:x()
end

return Vector
