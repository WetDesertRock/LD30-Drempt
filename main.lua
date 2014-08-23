local statements = require("lib.statements")

DEBUG = true

local GlobalState = statements.new()

function GlobalState:update(dt)
    if DEBUG then
        require("lib.lovebird").update(dt)
    end
end

function love.load()
    love.graphics.setBackgroundColor(131, 130, 124)
    math.randomseed(os.clock())

    G = nil

    statements.setGlobalState(GlobalState)
    statements.switchState(require('mainmenu')())
end

function love.keypressed(key,isrepeat)
end

function love.keypressed(k)
end


function love.keyreleased(k)
end
