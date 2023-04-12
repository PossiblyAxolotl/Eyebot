
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "CoreLibs/math"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "loadJson.lua"
import "transi.lua"
import "saves.lua"
import "object.lua"
import "player.lua"
import "menu.lua"
import "intro.lua"
import "pdParticles.lua"
mode = "menu"
local gfx <const> = playdate.graphics
local eyefont = gfx.font.new("gfx/eyefont")
gfx.setFont(eyefont)

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
        playerUpdate()
        updateButtons()
        gfx.sprite.update()
        tilemap:draw(0,0)
    end
    playdate.timer.updateTimers()
    Particles:update()
    trans()
end