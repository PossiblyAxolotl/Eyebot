
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
local tt = GrabObject(200,200,1)
local b = ObjectButton(300,200)
local w = PopupWall(300,60)

gfx.sprite.addEmptyCollisionSprite(0,0,400,20)
gfx.sprite.addEmptyCollisionSprite(0,0,20,240)
gfx.sprite.addEmptyCollisionSprite(380,0,20,240)
gfx.sprite.addEmptyCollisionSprite(0,220,400,20)
function playdate.update()
    playerUpdate()
    gfx.sprite.update()
    Particles:update()
    if b:justPressed() then
        w:popdown()
    end
    if b:justReleased() then
        w:popup()
    end
end