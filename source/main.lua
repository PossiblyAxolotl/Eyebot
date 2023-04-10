
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "CoreLibs/math"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "transi.lua"
import "object.lua"
import "player.lua"
import "menu.lua"
import "intro.lua"
import "pdParticles.lua"
mode = "menu"
local gfx <const> = playdate.graphics
local eyefont = gfx.font.new("gfx/eyefont")
gfx.setFont(eyefont)
saveslot = nil

function sign(x)
    return (x > 0 and 1) or (x == 0 and 0) or -1
end

function playdate.update()
    gfx.clear()
    if mode == "menu" then
        titleuiUpdate()
        Particles:update()
    elseif mode == "intro" then
        introUpdate()
    end
    trans()
end