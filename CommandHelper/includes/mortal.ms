proc('_mortal',@plr,
    @yml = ''
    @worldGM = ''
    @ploc = ploc(@plr)
    @yml = read('/home/minecraft/server/plugins/Multiverse-Core/worlds.yml')
    @yml = yml_decode(@yml)
    @worldGM = @yml['worlds'][@ploc['world']]['gameMode']
    queue_push(closure(set_attribute(puuid(@plr),'maxHealth',20)))
    queue_push(closure(runas('~console',"/minecraft:clear ".@plr)))
    queue_push(closure(runas('~console',"/sudo ".@plr." c:/trailsid none")))
    queue_push(closure(set_pmode(@plr,@worldGM)))
    queue_push(closure(runas('~console',"/effect ".@plr." clear")))
    queue_push(closure(runas('~console',"/fly ".@plr." off")))
    queue_push(closure(runas('~console',"/god ".@plr." off")))
    queue_push(closure(runas('~console','/undisguiseplayer '.@plr)))
    queue_push(closure(runas('~console',"/pex user ".@plr." group set mortal")))

)
