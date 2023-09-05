local gfx <const> = playdate.graphics

local cX, cY = 0,0

local sX, sY = 0,0

local stay = false

function camUpdate() -- math to lerp cam
    if stay == false then
        local newCX, newCY = getPlayerPos()
        cX = playdate.math.lerp(cX, -newCX+200, 0.2)
        cY = playdate.math.lerp(cY, -newCY+120, 0.2)
    else
        cX = playdate.math.lerp(cX, sX, 0.2)
        cY = playdate.math.lerp(cY, sX, 0.2)
    end
end

function setCam() -- move cam to position
    gfx.setDrawOffset(cX,cY)
end

function resetCamVars()
    cX,cY,sX,sY = 0,0,0,0
end

function startStay(_x, _y)
    sX = _x
    sY = _y
    stay = true
end

function endStay()
    stay = false
end

function resetCam() -- reset cam back to 0,0 for UI
    gfx.setDrawOffset(0,0)
end