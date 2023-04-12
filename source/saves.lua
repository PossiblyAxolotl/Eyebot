saveslot = nil

local names = {"Bobert","Jamie","Joan"}

function createSave()
    local dat = {
        playtime=0,
        level=1,
        collectibles=0,
        complete=false,
        name=names[math.random(#names)]
    }

    playdate.datastore.write(dat, "saves/slot"..saveslot)
end