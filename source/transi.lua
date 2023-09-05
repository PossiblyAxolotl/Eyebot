local gfx <const> = playdate.graphics

transing = 0
local topY, botY = 0, 0
isCovered = false

function transIn()
    transing = 20
    topY, botY = 0, 0
end

function transOut()
    transing = -20
    topY, botY = 0, 240
end

function trans()
    if transing > 0 then
        if botY < 240 then
            botY += transing
        else
            fullTrans()
            transOut()
        end
    elseif transing < 0 then
        if topY < 240 then
            topY -= transing
        else
            transing = 0
        end
    end
    
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0,topY,400,botY)
end