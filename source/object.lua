local gfx <const> = playdate.graphics

local objects <const> = {gfx.image.new("gfx/box")}
local btn <const> = gfx.image.new("gfx/button")
local pbtn <const> = gfx.image.new("gfx/pushbutton")
local wall <const> = {gfx.image.new('gfx/wallUp'),gfx.image.new('gfx/wallDown')}
local tabButton <const> = gfx.imagetable.new("gfx/buttonAnimated")
import "pdParticles.lua"

class("GrabObject").extends(gfx.sprite)
function GrabObject:init(x, y, image)
    self:moveTo(x,y)
    self:setImage(objects[image])
    self:setCollideRect(0,0,self.width,self.height)
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
    self:setCollideRect(2,0,43,20)
    self:add()
    self.pressed = false
    self.lp = false
    self.animFrame = 0
    self:setZIndex(0)
    self:setGroups({3})
end

function ObjectButton:onPressed()
end
function ObjectButton:onReleased()
end

function ObjectButton:update()
    if self.lp == false and self.pressed == true then self:onPressed() elseif self.lp == true and self.pressed == false then self:onReleased() end
    local sprs = self:overlappingSprites()
    self.lp = self.pressed
    for s = 1, #sprs, 1 do
        if sprs[s]:isa(GrabObject) or sprs[s].isPlayer then
            self.animFrame += 1
            self:setImage(tabButton[math.ceil(self.animFrame / 60 * 2)+1])
            self.pressed = true
            if self.animFrame > 59 then self.animFrame = 0 end
            sprs[s].fall = 0
            sprs[s]:moveTo(playdate.math.lerp(sprs[s].x,self.x + 12- (sprs[s].width/2), 0.1),playdate.math.lerp(sprs[s].y,self.y + 3- (sprs[s].height/2), 0.1))
            break
        end
        self.pressed = false
    end

    if #sprs < 1 then self.pressed = false self:setImage(tabButton[1]) self.animFrame = 0 end
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

class("PushButton").extends(gfx.sprite)
function PushButton:init(x, y,permanent)
    self:moveTo(x,y)
    self:setImage(pbtn)
    self:setCollideRect(0,0,7,24)
    self:add()
    self:setZIndex(self.y)
    self.toggled = false
    self.lp = false
    self.pressed = false
    self.active = true
    self.permanent = permanent or false
end

function PushButton:onPressed()
end

function PushButton:press()
    if self.active then
    self.pressed = true
    self.toggled = not self.toggled
    end
end

function PushButton:update()
    if self.lp == false and self.pressed == true then
        self:onPressed()
    end

    if self.pressed ~= self.lp then
        self.lp = self.pressed
    elseif not self.permanent then
        self.pressed = false
    end
end

function PushButton:disable()
    self.active = false
end

function PushButton:enable()
    self.active = true
end

function PushButton:justPressed()
    if self.lp == false and self.pressed == true then
        self.lp = true
        return true
    else
        return false
    end
end

function PushButton:justReleased()
    if self.lp == true and self.pressed == false then
        self.lp = false
        return true
    else
        return false
    end
end  

class("TimedButton").extends(PushButton)
function PushButton:init(x, y,time)
    self:moveTo(x,y)
    self:setImage(pbtn)
    self:setCollideRect(0,0,7,24)
    self:add()
    self:setZIndex(self.y)
    self.pressed = false
    self.time = time or 100
    self.timer = nil
    self.lp = false
    self.permanent = true
    self.active = true
end

function TimedButton:release()
    self.timer = nil
    self.pressed = false
end

function TimedButton:update()
    if self.timer and self.timer.currentTime >= self.time then
        self:release()
        self:onReleased()
    end
end

function TimedButton:disable()
    if self.timer then
        self.timer:remove()
        self.timer = nil
    end
    self.active = false
end

function TimedButton:onPressed()
end

function TimedButton:onReleased()
end

function TimedButton:getTimeLeft()
    if self.timer then 
        return math.ceil( (self.time - self.timer.currentTime)/1000 ) 
    else 
        return nil 
    end
end

function TimedButton:press()
    self:onPressed()
    if self.active then
    self.pressed = true
    if self.timer then self.timer:remove() end
    self.timer = playdate.timer.new(self.time)
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

function PopupWall:update()
    if self.up and self:collisionsEnabled() == false then
        self:popup()
    end
end

function PopupWall:popup()
    self.up = true
    self:setCollisionsEnabled(true)
    if #self:overlappingSprites() > 0 then
        self:setCollisionsEnabled(false)
    else
        self:setImage(wall[1])
        self:setZIndex(self.y)
    end
end

function PopupWall:popdown()
    self.up = false
    self:setCollisionsEnabled(false)
    self:setImage(wall[2])
    self:setZIndex(0)
end

function PopupWall:setPop(pop)
    if pop == true then
        self:popup()
    else
        self:popdown()
    end
end