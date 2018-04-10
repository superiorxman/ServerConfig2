proc('_coolDown',@coolDownName,@coolDownTime,@player,@checkOnly = false,

    @lastUsedPower = import(@player."lastUsed".@coolDownName)
    if(@lastUsedPower + @coolDownTime > time() / 1000){
        assign(@timeleft, subtract(add(@lastUsedPower, @coolDownTime), divide(time(),1000)))
        msg(color('RED').'['.color('DARK_RED').'Error'.color('RED').'] '.color('GRAY').'You must wait another '.color('GOLD').round(@timeleft).color('GRAY').' seconds before you can use this again!')
        return(true)
    }
    if(@checkOnly == false){
        export(@player."lastUsed".@coolDownName, time() / 1000)
    }
    return(false)
)
