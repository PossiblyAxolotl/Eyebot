local gfx <const> = playdate.graphics

local function decodeLevel(level)
    local data = json.decodeFile(level)
    return data.name, data.player, data.exit, data.tiles, data.props, data.triggers
end

local levelData = {tileSprites={},props={},buttons={}}

local tilemap = gfx.tilemap.new()
local imgTiles = gfx.imagetable.new("gfx/tilemap")
tilemap:setImageTable(imgTiles)

function updateButtons()
    for bID = 1, #levelData.buttons, 1 do
        levelData.buttons[bID]:update()
    end
end

function drawTilemap()
    tilemap:draw(0,0)
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
            if prop.button.type == "big" then
                local button = ObjectButton(prop.button.x,prop.button.y)
                button.onPressed = function() wall:popdown() end
                button.onReleased = function() wall:popup() end
                levelData.buttons[#levelData.buttons+1] = button
            end
        end
    end

    tilemap:setSize(#tiles[1],#tiles)
    for y = 1, #tiles, 1 do
        for x = 1, #tiles[1] do
            local tile = tiles[y][x]
            if tile > 5 and tile < 13 then
                local tileSpr = gfx.sprite.new(imgTiles[tile])
                tileSpr:setCollideRect(0,20,64,44)
                tileSpr:add()
                tileSpr:moveTo(x*64,y*64)
                tileSpr:setZIndex(1000)
                levelData.tileSprites[#levelData.tileSprites+1] = tileSpr
            elseif tile > 0 then
                local tileSpr = gfx.sprite.new(imgTiles[tile])
                tileSpr:setCollideRect(0,20,64,24)
                tileSpr:add()
                tileSpr:moveTo(x*64,y*64)
                tileSpr:setZIndex(y*64)
                levelData.tileSprites[#levelData.tileSprites+1] = tileSpr
            end
        end
    end
end