
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "CoreLibs/math"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "loadJson.lua"
import "transi.lua"
import "saves.lua"
import "camera.lua"
import "object.lua"
import "player.lua"
import "menu.lua"
import "intro.lua"
import "pdParticles.lua"
mode = "splash"

local gfx <const> = playdate.graphics

playdate.timer.new(300, function() fullTrans = function() mode = "menu" gfx.setBackgroundColor(gfx.kColorWhite) end transIn() end)
gfx.setBackgroundColor(gfx.kColorBlack)
local eyefont = gfx.font.new("gfx/eyefont")
gfx.setFont(eyefont)

local imgSplash = gfx.image.new("gfx/splash")

math.randomseed(playdate.getSecondsSinceEpoch())

function sign(x)
    return (x > 0 and 1) or (x == 0 and 0) or -1
end

function playdate.update()
    print(mode)
    gfx.clear()
    if mode == "menu" then
        titleuiUpdate()
    elseif mode == "intro" then
        introUpdate()
    elseif mode == "game" then
        camUpdate()
        setCam()
        playerUpdate()
        updateButtons()
        gfx.sprite.update()
        drawTilemap()
    elseif mode == "splash" then
        imgSplash:draw(0,0)
    end
    playdate.timer.updateTimers()
    Particles:update()
    resetCam()
    trans()
end