local gfx <const> = playdate.graphics
local imgGrid = gfx.image.new("gfx/introframes/gridtile")
assert(imgGrid)
local frames = gfx.imagetable.new("gfx/introframes/intro")
local frame = 1
local max = 21
local framerate = 0.5
local gridX, gridY = 400,240

function beginIntro()
    mode = "intro"
    frame = 1
    max = 21
    framerate = 0.5
    gridX, gridY = 0,0
end

function introUpdate()
    --imgGrid:drawTiled(0,0,400, 240)
    --if gridX == 400 then
        frames[math.floor(frame)]:draw(0,0)
        if frame < max then frame += framerate end

        if playdate.buttonJustPressed(playdate.kButtonA) and frame == max then
            if max == 21 or max == 41 then max += 5 end
            if max == 65 then max = 75 end
        end
        if playdate.buttonJustPressed(playdate.kButtonB) and frame == max then
            if max == 26 then max = 41 end
            if max == 46 then max = 65 end
        end

        if frame > 70 then framerate = 0.3
        elseif frame > 65 then framerate = 0.4 end
    --[[else
        if gridY < 240 then gridY += 4 end
        gridX += 4
    end]]
end 