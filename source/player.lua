local gfx <const> = playdate.graphics

local idles <const> = {gfx.imagetable.new("gfx/idle/front"),gfx.imagetable.new("gfx/idle/frontright"),gfx.imagetable.new("gfx/idle/right"),gfx.imagetable.new("gfx/idle/backright"),gfx.imagetable.new("gfx/idle/back"),gfx.imagetable.new("gfx/idle/backleft"),gfx.imagetable.new("gfx/idle/left"),gfx.imagetable.new("gfx/idle/frontleft")}
local walks <const> = {gfx.imagetable.new("gfx/walk/front"),gfx.imagetable.new("gfx/walk/frontright"),gfx.imagetable.new("gfx/walk/right"),gfx.imagetable.new("gfx/walk/backright"),gfx.imagetable.new("gfx/walk/back"),gfx.imagetable.new("gfx/walk/backleft"),gfx.imagetable.new("gfx/walk/left"),gfx.imagetable.new("gfx/walk/frontleft")}

local dirs <const> = {
    {6,5,4},
    {7,0,3},
    {8,1,2}
}

local degDirs <const> = {
    {8,1,2},
    {7,0,3},
    {6,5,4}
}

local playerAnimSpeed <const> = 2

local sprPlayer = gfx.sprite.new(walks[1][1])
local sprInteract = gfx.sprite.new()
sprInteract:setCollideRect(-10,-10,20,40)
sprPlayer:setCollideRect(19,23,39,39)
sprPlayer:setGroups({1})
sprInteract:setGroups({2})
sprPlayer:add()
sprInteract:add()
local direction = 1
local frame = 1
local xVel, yVel = 0,0
local speed <const> = 4

local grabbed = nil

local inDirX, inDirY = 0,0

local spawnX, spawnY = 0,0

function playerSetup(x,y)
    sprPlayer:moveTo(x,y)
    spawnX, spawnY = x, y
end

function playerUpdate()
    local inX, inY = 0,0
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        inY -= 1
    elseif playdate.buttonIsPressed(playdate.kButtonDown) then
        inY += 1
    end
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        inX += 1
    elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
        inX -= 1
    end

    xVel, yVel = playdate.math.lerp(xVel, inX * speed, 0.2), playdate.math.lerp(yVel, inY * speed, 0.3)

    sprPlayer:moveBy(xVel, 0)
    while #sprPlayer:overlappingSprites() > 0 do
        print(#sprPlayer:overlappingSprites())
        sprPlayer:moveBy(sign(-xVel), 0)
    end
    sprPlayer:moveBy(0, yVel)
    while #sprPlayer:overlappingSprites() > 0 do
        sprPlayer:moveBy(0, sign(-yVel))
    end

    local newDir = dirs[inY+2][inX+2]
    if newDir ~= 0 then
        direction = newDir
        inDirX = inX
        inDirY = inY
    end

    sprInteract:moveTo(sprPlayer.x + inDirX * 40, sprPlayer.y - 10 + inDirY * 30)

    if playdate.buttonJustPressed(playdate.kButtonA) then
        if #sprInteract:overlappingSprites() > 0 and not grabbed then
            grabbed = sprInteract:overlappingSprites()[1]
            if grabbed:isa(GrabObject) then
                grabbed:setCollisionsEnabled(false)
            else
                grabbed = nil
            end
        elseif grabbed then
            grabbed:setCollisionsEnabled(true)
            grabbed = nil
        end
    end
    
    if grabbed then
        local yExtra = 0
        if inDirY > 0 then yExtra =  12 end
        grabbed:moveTo(playdate.math.lerp(grabbed.x, sprInteract.x + inDirX * 5, 0.4),playdate.math.lerp(grabbed.y, sprInteract.y + inDirY * 5 + yExtra, 0.4))

    end

    if inX ~= 0 or inY ~= 0 then
        sprPlayer:setImage(walks[math.floor(direction+0.5)][frame*playerAnimSpeed % (#walks[math.floor(direction+0.5)])+1])
        frame += 1
        if frame > (#walks[1] + 1) * playerAnimSpeed then
            frame = 0
        end
    else
        sprPlayer:setImage(idles[math.floor(direction+0.5)][frame % (#idles[math.floor(direction+0.5)])+1])
        frame += 1
        if frame > #idles[1] + 1 then
            frame = 0
        end
    end
end