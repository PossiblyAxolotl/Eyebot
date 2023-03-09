
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "CoreLibs/math"
import "object.lua"
import "player.lua"
import "pdParticles.lua"
local gfx <const> = playdate.graphics

playerSetup(200,120)

function sign(x)
    return (x > 0 and 1) or (x == 0 and 0) or -1
end

local t = GrabObject(60,60,1)

gfx.sprite.addEmptyCollisionSprite(0,0,400,20)
gfx.sprite.addEmptyCollisionSprite(0,0,20,240)
gfx.sprite.addEmptyCollisionSprite(380,0,20,240)
gfx.sprite.addEmptyCollisionSprite(0,220,400,20)
function playdate.update()
    playerUpdate()
    gfx.sprite.update()
end