local statements = require("lib.statements")

DEBUG = false

local GlobalState = statements.new()

function GlobalState:update(dt)
    if DEBUG then
        require("lib.lovebird").update(dt)
    end
end

function love.load()
    love.graphics.setBackgroundColor(131, 130, 124)
    math.randomseed(os.clock())

    G = require('game')(DEBUG)

    statements.setGlobalState(GlobalState)
    statements.switchState(G)
end

function love.keypressed(key,isrepeat)
end

function love.keypressed(k)
end


function love.keyreleased(k)
end
