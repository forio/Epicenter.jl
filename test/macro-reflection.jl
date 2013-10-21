
module MercutioTest


using Mercutio

beep = 55

@parameter beep

function meep()
    global beep = beep + 1
end


end
