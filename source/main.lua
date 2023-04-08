
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "CoreLibs/math"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "object.lua"
import "player.lua"
import "menu.lua"
import "pdParticles.lua"
local gfx <const> = playdate.graphics
local eyefont = gfx.font.new("gfx/eyefont")
gfx.setFont(eyefont)

function sign(x)
    return (x > 0 and 1) or (x == 0 and 0) or -1
end


function playdate.update()
    gfx.clear()
    titleuiUpdate()
end