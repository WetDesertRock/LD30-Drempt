local keybinds = {
    up = {"up","w"},
    left = {"left","a"},
    right = {"right","d"},
    down = {"down","s"},
    shoot = {" ","mbt-1"}
}

local _ = {}

function _.isDown(a)
    for _,k in pairs(keybinds[a]) do
        if k == "mbt-1" then
            if love.mouse.isDown("l") then return true end
        end

        if love.keyboard.isDown(k) then return true end
    end
end

return _
