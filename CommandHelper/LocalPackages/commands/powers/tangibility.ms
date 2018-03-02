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
            set_pmode(@plr,'ADVENTURE')
            if(!has_permission(@plr,'essentials.fly')){
                set_pflight(@plr,false)
            }
        }
    )
)
