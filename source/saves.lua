saveslot = nil

function createSave()
    local dat = {
        playtime=0,
        level=1,
        collectibles=0,
        complete=false,
        name="BOT#"..math.random(1000,9999)
    }

    playdate.datastore.write(dat, "saves/slot"..saveslot)
end