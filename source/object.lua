local gfx <const> = playdate.graphics

local objects <const> = {gfx.image.new("gfx/box")}

class("GrabObject").extends(gfx.sprite)
function GrabObject:init(x, y, image)
    self:moveTo(x,y)
    self:setImage(objects[image])
    self:setCollideRect(0,0,16,16)
    self:add()
end