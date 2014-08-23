function love.load()
    love.graphics.setBackgroundColor(151, 149, 141)
    G = require('game')()
    isrunning = true
end

function love.keypressed(key,isrepeat)
end

function love.keypressed(k)
end


function love.keyreleased(k)
end


function love.update(dt)
    if isrunning then
        G:update(dt)
    end
    -- if G.debug then
        require("lib.lovebird").update(dt)
    -- end
end


function love.draw()
    G:draw()
end
