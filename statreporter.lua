local json = require('lib.dkjson')

local _ = {}

function _.init()
    _.channel = love.thread.getChannel("stat_channel")
    _.thread = love.thread.newThread("statsender.lua")
    if REPORTSTATS then
        _.thread:start()
    end
end

function _.report(type,data,incpstats)
    local msg = {type=type,data=data,debug=DEBUG}
    if incpstats then
        local stats = require("playerstats")
        local s = {}
        for i,key in ipairs({"hp","movespeed","turnrate","shotrate","points"}) do
            s[key] = stats[key]
        end

        msg.data.stats = s
    end
    if REPORTSTATS then
        _.channel:push(json.encode(msg,{indent=false}))
    end
end

return _
