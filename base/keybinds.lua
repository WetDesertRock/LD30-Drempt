local keybinds = {
    up = {"up","w"},
    left = {"left","a"},
    right = {"right","d"},
    down = {"down","s"},
    shoot = {" "}
}

local _ = {}

function _.isDown(a)
    for _,k in pairs(keybinds[a]) do
        if love.keyboard.isDown(k) then return true end
    end
end

return _
