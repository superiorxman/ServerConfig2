register_command(intangible, 
    array(
        description: 'Power',
        permission: 'ch.alias.intangible',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',
        executor: closure() {
            @plr = player()
            set_pmode(@plr, 'SPECTATOR')
            set_pflight(@plr,true)
            set_pflying(@plr,true)
        }
    )
)

register_command(tangible, 
    array(
        description: 'Power',
        permission: 'ch.alias.tangible',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',
        executor: closure() {        
            @plr = player()
            @ploc = ploc(@plr)
            @yml = read('/home/minecraft/server/plugins/Multiverse-Core/worlds.yml')
            @yml = yml_decode(@yml)
            @worldGM = @yml['worlds'][@ploc['world']]['gameMode']
            set_pmode(@plr,@worldGM)
            if(!has_permission(@plr,'essentials.fly')){
                set_pflight(@plr,false)
            }
        }
    )
)
