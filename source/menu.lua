local gfx <const> = playdate.graphics
menuID = 0
sel = nil
local tabBtn = gfx.imagetable.new("gfx/ui/uiButton")
local tabTrash = gfx.imagetable.new("gfx/ui/trash")
local tabSlot = gfx.imagetable.new("gfx/ui/slot")
local tabConf = gfx.imagetable.new("gfx/ui/check")
local tabDec = gfx.imagetable.new("gfx/ui/x")
local imgSave = gfx.image.new("gfx/ui/savefile")
assert(tabBtn)
assert(tabTrash)
assert(tabSlot)
assert(imgSave)

local menuOptions = {"Play","Editor","Extras"}
local menuPos = {-20,-20,-20,-20}
local menu = playdate.ui.gridview.new(0, 30)
menu:setNumberOfRows(#menuOptions)

local confirmdeny = playdate.ui.gridview.new(30, 30)
confirmdeny:setNumberOfRows(2)
local confirmdenyY = 0
local confMessage = "amogus SUS"

local slots = playdate.ui.gridview.new(100, 30)
local slotsPos = {0,0,0,0,0,0}
slots:setNumberOfColumns(3)
slots:setNumberOfRows(2)

local function confirm()
    print("a")
end
local function deny()
    print("b")
end

local sdata = {playdate.datastore.read("saves/slot1"),playdate.datastore.read("saves/slot2"),playdate.datastore.read("saves/slot3")}

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
    if transing == 0 then
        if playdate.buttonJustPressed(playdate.kButtonA) then
            sel = menu:getSelectedRow()
        elseif playdate.buttonJustReleased(playdate.kButtonA) then
            if sel == menu:getSelectedRow() then
                if sel == 1 then
                    slots:setSelection(1,1,2)
                    fullTrans = function() menuID = 1 end
                    transIn()
                end
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
end

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
        if sel == row + 2* (column-1) and menuID == 1 then
            tabTrash[2]:draw(54 + 133*(column-1),160+slotsPos[3+column])
        else
            tabTrash[1]:draw(54 + 133*(column-1),160+slotsPos[3+column])
        end
    else
        if sdata[column] == nil then
            if sel == row + 2* (column-1) and menuID == 1 then
                tabSlot[2]:draw(9+ 133*(column-1),30+slotsPos[column])
                gfx.drawText("NO SAVE",9+ 133*(column-1) + 60 - gfx.getTextSize("NO SAVE")/2,30+slotsPos[column]+ 50)
            else
                tabSlot[1]:draw(9+ 133*(column-1),30+slotsPos[column])
                gfx.drawText("NO SAVE",9+ 133*(column-1) + 58 - gfx.getTextSize("NO SAVE")/2,30+slotsPos[column]+ 48)
            end
        else
            if sel == row + 2* (column-1) and menuID == 1 then
                tabSlot[2]:draw(9+ 133*(column-1),30+slotsPos[column])
                gfx.drawText(sdata[column].name,11+ 133*(column-1) + 58 - gfx.getTextSize(sdata[column].name)/2,72+slotsPos[column])
                gfx.drawText(sdata[column].collectibles.."/24",11+ 133*(column-1) + 58 - gfx.getTextSize(sdata[column].collectibles.."/24")/2,87+slotsPos[column])
                gfx.drawText(math.floor(sdata[column].playtime/60).."min",11+ 133*(column-1) + 58 - gfx.getTextSize(math.floor(sdata[column].playtime/60).."min")/2,125+slotsPos[column])

            else
                tabSlot[1]:draw(9+ 133*(column-1),30+slotsPos[column])
                gfx.drawText(sdata[column].name,9+ 133*(column-1) + 58 - gfx.getTextSize(sdata[column].name)/2,70+slotsPos[column])
                gfx.drawText(sdata[column].collectibles.."/24",9+ 133*(column-1) + 58 - gfx.getTextSize(sdata[column].collectibles.."/24")/2,85+slotsPos[column])
                gfx.drawText(math.floor(sdata[column].playtime/60).."min",9+ 133*(column-1) + 58 - gfx.getTextSize(math.floor(sdata[column].playtime/60).."min")/2,123+slotsPos[column])
            end
        end
    end
end

local function slotsUpdate()
    slots:drawInRect(0, 0, 400,240)
    playdate.timer.updateTimers()
    if transing == 0 then
        if playdate.buttonJustPressed(playdate.kButtonA) then
            selS, selR, selC = slots:getSelection()
            sel = selR + 2* (selC-1)
        elseif playdate.buttonJustReleased(playdate.kButtonA) then
            selS, selR, selC = slots:getSelection()
            if sel == selR + 2* (selC-1) then
                confirmdeny:setSelection(1,1,1)
                if sel == 1 then if sdata[1] == nil then fullTrans = beginIntro else fullTrans = function() loadLevel("levels/example.json") mode = "game" end end transIn() saveslot = 1 end
                if sel == 3 then if sdata[2] == nil then fullTrans = beginIntro else fullTrans = function() loadLevel("levels/example.json") mode = "game" end end transIn() saveslot = 2 end
                if sel == 5 then if sdata[3] == nil then fullTrans = beginIntro else fullTrans = function() loadLevel("levels/example.json") mode = "game" end end transIn() saveslot = 3 end
                if sel == 2 then menuID = 9 confirmdenyY = 50 confMessage = "Delete Save 1?" deny = function() menuID = 1 end confirm = function() playdate.datastore.delete("saves/slot1") sdata[1] = nil menuID = 1 end end
                if sel == 4 then menuID = 9 confirmdenyY = 50 confMessage = "Delete Save 2?" deny = function() menuID = 1 end confirm = function() playdate.datastore.delete("saves/slot2") sdata[2] = nil menuID = 1 end end
                if sel == 6 then menuID = 9 confirmdenyY = 50 confMessage = "Delete Save 3?" deny = function() menuID = 1 end confirm = function() playdate.datastore.delete("saves/slot3") sdata[3] = nil menuID = 1 end end
            end
            sel = nil
        end
        if playdate.buttonJustPressed(playdate.kButtonB) then
            sel = nil
            fullTrans = function() menuID = 0 end
            transIn()
        end
    if playdate.buttonJustPressed(playdate.kButtonDown) then
        slots:selectNextRow()
        sel = nil
    end
    if playdate.buttonJustPressed(playdate.kButtonUp) then
        slots:selectPreviousRow()
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
end

local confdenybuts = {0,0}

function confirmdeny:drawCell(section, row, column, selected, x, y, width, height)
    confirmdenyY = playdate.math.lerp(confirmdenyY, 0, 0.2)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0,180 + confirmdenyY,400,60+confirmdenyY)
    gfx.setColor(gfx.kColorBlack)
    gfx.setLineWidth(3)
    gfx.drawLine(0,178+confirmdenyY,400,178+confirmdenyY)
    gfx.drawText(confMessage,200-gfx.getTextSize(confMessage)/2,180+confirmdenyY)

    if row == 1 and selected then
        confdenybuts[1] = playdate.math.lerp(confdenybuts[1],-5,0.2)
        confdenybuts[2] = playdate.math.lerp(confdenybuts[2],0,0.2)
    elseif row == 2 and selected then
        confdenybuts[2] = playdate.math.lerp(confdenybuts[2],-5,0.2)
        confdenybuts[1] = playdate.math.lerp(confdenybuts[1],0,0.2)
    end
    if sel == 1 then
        tabDec[2]:draw(145,200+confirmdenyY+confdenybuts[1])
    else
        tabDec[1]:draw(145,200+confirmdenyY+confdenybuts[1])
    end
    if sel == 2 then
        tabConf[2]:draw(225,200+confirmdenyY+confdenybuts[2])
    else
        tabConf[1]:draw(225,200+confirmdenyY+confdenybuts[2])
    end
end

local function confirmUpdate()
    slots:drawInRect(0,0,400,240)
    confirmdeny:drawInRect(0, 0, 400,240)
        
        if playdate.buttonJustPressed(playdate.kButtonA) then
            selS, selR, selC = confirmdeny:getSelection()
            sel = selR
        elseif playdate.buttonJustReleased(playdate.kButtonA) then
            selS, selR, selC = confirmdeny:getSelection()
            if sel == selR then
                if sel == 1 then deny() else confirm() end
            end
            sel = nil
        end

    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        confirmdeny:selectPreviousRow()
        sel = nil
    end
    if playdate.buttonJustPressed(playdate.kButtonRight) then
        confirmdeny:selectNextRow()
        sel = nil
    end
end

local updates = {}
updates[0] = menuUpdate
updates[1] = slotsUpdate
updates[9] = confirmUpdate

function titleuiUpdate()
    updates[menuID]()
end