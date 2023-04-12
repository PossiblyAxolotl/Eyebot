local function decodeLevel(level)
    local data = json.decodeFile(level)
    return data.name, data.player, data.exit, data.tiles, data.props, data.triggers
end

local levelData = {props={},buttons={}}

function updateButtons()
    for bID = 1, #levelData.buttons, 1 do
        levelData.buttons[bID]:update()
    end
end

function loadLevel(level)
    local name, player, exit, tiles, props, triggers = decodeLevel(level)

    playerSetup(player.x,player.y)

    for propNo = 1, #props, 1 do
        local prop = props[propNo]
        if prop.type == "box" then
            local box = GrabObject(prop.x,prop.y,1)
            levelData.props[#levelData.props+1] = box
        end
        if prop.type == "popup" then
            local wall = PopupWall(prop.x,prop.y)
            levelData.props[#levelData.props+1] = wall
            if prop.button.type == "timed" then
                local button = TimedButton(prop.button.x,prop.button.y,prop.button.time)
                button.onPressed = function() wall:popdown() end
                button.onReleased = function() wall:popup() end
                levelData.buttons[#levelData.buttons+1] = button
            end
        end
    end
end