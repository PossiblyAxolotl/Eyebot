local gfx <const> = playdate.graphics

local objects <const> = {gfx.image.new("gfx/box")}
local btn <const> = gfx.image.new("gfx/button")
local wall <const> = {gfx.image.new('gfx/wallUp'),gfx.image.new('gfx/wallDown')}
import "pdParticles.lua"

class("GrabObject").extends(gfx.sprite)
function GrabObject:init(x, y, image)
    self:moveTo(x,y)
    self:setImage(objects[image])
    self:setCollideRect(0,0,16,16)
    self:add()
    self.fall = 0
    self:setZIndex(self.y)
    self.velX, self.velY = 0, 0
end

function GrabObject:update()
--    self:moveBy(self.velX, 0)
--    local h = false
--    while #self:overlappingSprites() > 0 do
--        self:moveBy(sign(-self.velX), 0)
--        h = true
--    end
--    self:moveBy(0, self.velY)
--    while #self:overlappingSprites() > 0 do
--        self:moveBy(0, sign(-self.velY))
--        h = true
--        self.fall = 0
--    end
--    if h == true then self.velY = 0 self.velX = 0 end
--    self.velX = playdate.math.lerp(self.velX, 0, 0.1)
--    self.velY = playdate.math.lerp(self.velY, 0, 0.1)

    if self.velX ~= 0 or self.velY ~= 0 then
        self:setZIndex(self.y)
    end

    if self.fall < 0 and self:collisionsEnabled() == true then
        self:moveBy(0,4)
        self.fall += 4
        self:setZIndex(self.y)
    end
end

class("ObjectButton").extends(gfx.sprite)
function ObjectButton:init(x, y)
    self:moveTo(x,y)
    self:setImage(btn)
    self:setCollideRect(0,0,16,16)
    self:add()
    self.fall = 0
    self:setZIndex(self.y)
    self.pressed = false
    self.lp = false
    self:setGroups({3})
    self:setZIndex(0)
end

function ObjectButton:update()
    local sprs = self:overlappingSprites()
    self.lp = self.pressed
    for s = 1, #sprs, 1 do
        if sprs[s]:isa(GrabObject) then
            self.pressed = true
            break
        end
        self.pressed = false
    end

    if #sprs < 1 then self.pressed = false end
end

function ObjectButton:justPressed()
    if self.lp == false and self.pressed == true then
        return true
    else
        return false
    end
end

function ObjectButton:justReleased()
    if self.lp == true and self.pressed == false then
        return true
    else
        return false
    end
end

class("PopupWall").extends(gfx.sprite)
function PopupWall:init(x, y)
    self:moveTo(x,y)
    self:setImage(wall[1])
    self:setCollideRect(0,0,32,32)
    self:add()
    self.up = true
    self:setZIndex(y)
end

function PopupWall:popup()
    self.up = true
    self:setCollisionsEnabled(true)
    self:setImage(wall[1])
    self:setZIndex(self.y)
end

function PopupWall:popdown()
    self.up = false
    self:setCollisionsEnabled(false)
    self:setImage(wall[2])
    self:setZIndex(0)
end