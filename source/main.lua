
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "CoreLibs/math"
import "CoreLibs/timer"
import "object.lua"
import "player.lua"
import "pdParticles.lua"
local gfx <const> = playdate.graphics

playerSetup(200,120)

function sign(x)
    return (x > 0 and 1) or (x == 0 and 0) or -1
end

--local t = GrabObject(60,60,1)
--local tt = GrabObject(200,200,1)
local w = PopupWall(260,120)
local ww = PopupWall(300,120)
local pb = TimedButton(100,100,3000)
local disb = PushButton(370,60)

ww:popdown()

gfx.sprite.addEmptyCollisionSprite(0,0,400,20)
gfx.sprite.addEmptyCollisionSprite(0,0,20,240)
gfx.sprite.addEmptyCollisionSprite(260,0,40,90)
gfx.sprite.addEmptyCollisionSprite(260,150,40,90)
gfx.sprite.addEmptyCollisionSprite(0,220,400,20)
function playdate.update()
    playerUpdate()
    gfx.sprite.update()
    playdate.timer.updateTimers()
    Particles:update()

    if pb:justPressed() then
        ww:popup()
        w:popdown()
        print('pre')
    end

    if pb:justReleased() then
        ww:popdown()
        w:popup()
        print("rel")
    end

    if disb.pressed then
        pb:disable()
        ww:popdown()
        w:popdown()
    end

    if pb:getTimeLeft() then
        gfx.drawText(pb:getTimeLeft(),100,100)
    end
end