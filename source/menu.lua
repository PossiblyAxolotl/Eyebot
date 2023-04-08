local gfx <const> = playdate.graphics
local menuID = 0
sel = nil
local tabBtn = gfx.imagetable.new("gfx/ui/uiButton")
local tabTrash = gfx.imagetable.new("gfx/ui/trash")
local tabSlot = gfx.imagetable.new("gfx/ui/slot")
assert(tabBtn)
assert(tabTrash)
assert(tabSlot)

local menuOptions = {"Play","Editor","Extras"}
local menuPos = {-20,-20,-20,-20}
local menu = playdate.ui.gridview.new(0, 30)
menu:setNumberOfRows(#menuOptions)

function menu:drawCell(section, row, column, selected, x, y, width, height)
    if selected then
        menuPos[row]= playdate.math.lerp(menuPos[row], 0, 0.2)
    else
        menuPos[row]= playdate.math.lerp(menuPos[row], -20, 0.2)
    end
    if sel == row then
        tabBtn[2]:draw(x+ menuPos[row], y)
        gfx.drawTextInRect(menuOptions[row], x-18+menuPos[row], y+5, width, height, nil, "...", kTextAlignment.right)
    else
        tabBtn[1]:draw(x+ menuPos[row], y)
        gfx.drawTextInRect(menuOptions[row], x-20+menuPos[row], y+3, width, height, nil, "...", kTextAlignment.right)
    end
end

local function menuUpdate()
    menu:drawInRect(0, 240-#menuOptions * 30, 200, #menuOptions * 30)
    playdate.timer.updateTimers()

        if playdate.buttonJustPressed(playdate.kButtonA) then
            sel = menu:getSelectedRow()
        elseif playdate.buttonJustReleased(playdate.kButtonA) then
            if sel == menu:getSelectedRow() then
                menuID = sel
            end
            sel = nil
        end

    if playdate.buttonJustPressed(playdate.kButtonDown) then
        menu:selectNextRow()
        sel = nil
    end
    if playdate.buttonJustPressed(playdate.kButtonUp) then
        menu:selectPreviousRow()
        sel = nil
    end
end

local slots = playdate.ui.gridview.new(100, 30)
local slotsPos = {0,0,0,0,0,0}
slots:setNumberOfColumns(3)
slots:setNumberOfRows(2)

function slots:drawCell(section, row, column, selected, x, y, width, height)
    
    if row % 2 == 0 then
        if selected then
            slotsPos[3 + column] = playdate.math.lerp(slotsPos[3 + column], -10, 0.2)
        else
            slotsPos[3 + column] = playdate.math.lerp(slotsPos[3 + column], 0, 0.2)
        end
    else
        if selected then
            slotsPos[column] = playdate.math.lerp(slotsPos[column], -10, 0.2)
        else
            slotsPos[column] = playdate.math.lerp(slotsPos[column], 0, 0.2)
        end
    end

    if row % 2 == 0 then
        if sel == row + 2* (column-1) then
            tabTrash[2]:draw(54 + 133*(column-1),160+slotsPos[3+column])
        else
            tabTrash[1]:draw(54 + 133*(column-1),160+slotsPos[3+column])
        end
    else
        if sel == row + 2* (column-1) then
            tabSlot[2]:draw(9+ 133*(column-1),30+slotsPos[column])
        else
            tabSlot[1]:draw(9+ 133*(column-1),30+slotsPos[column])
        end
    end
end

local function slotsUpdate()
    slots:drawInRect(0, 0, 400,240)
    playdate.timer.updateTimers()

        if playdate.buttonJustPressed(playdate.kButtonA) then
            selS, selR, selC = slots:getSelection()
            sel = selR + 2* (selC-1)
        elseif playdate.buttonJustReleased(playdate.kButtonA) then
            selS, selR, selC = slots:getSelection()
            if sel == selR + 2* (selC-1) then
                print(sel)
            end
            sel = nil
        end

        if playdate.buttonJustPressed(playdate.kButtonB) then
            sel = nil
            menuID = 0
        end

    if playdate.buttonJustPressed(playdate.kButtonDown) then
        slots:selectNextRow()
        sel = nil
    end
    if playdate.buttonJustPressed(playdate.kButtonUp) then
        slots:selectPreviousRow()
        sel = nil
    end
    if playdate.buttonJustPressed(playdate.kButtonDown) then
        slots:selectNextRow()
        sel = nil
    end
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        slots:selectPreviousColumn()
        sel = nil
    end
    if playdate.buttonJustPressed(playdate.kButtonRight) then
        slots:selectNextColumn()
        sel = nil
    end
end

local updates = {}
updates[0] = menuUpdate
updates[1] = slotsUpdate

function titleuiUpdate()
    updates[menuID]()
end