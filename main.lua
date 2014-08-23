function love.load()
    love.graphics.setBackgroundColor(190, 187, 177)
    G = require('game')()
end

function love.keypressed(key,isrepeat)
end

function love.keypressed(k)
end


function love.keyreleased(k)
end


function love.update(dt)
    G:update(dt)
end


function love.draw()
    G:draw()
end
