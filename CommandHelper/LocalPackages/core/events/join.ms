bind('player_join',null,null,@event){
    
    include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
    @plr = player()
    @class = _getheroclass(@plr)
    try(
        @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
        @hero = yml_decode(@contents)
    ,
        @hero = associative_array('class':'')
    )
    include('/home/minecraft/server/plugins/CommandHelper/includes/changeSkin.ms')
    include('/home/minecraft/server/plugins/CommandHelper/includes/changeTrail.ms')
    
    
    @plrs = all_players()
    
    if(@hero['class'] == 'jailed')
    {
        sudo("/undisguise ".@plr)
        sudo("/minecraft:clear ".@plr)
        die()
    }
    
    export(@plr."isConfused","false")    
    export(@plr."speedEffects","false")

    if(@hero['class'] == 'mortal'){
        runas('~console',"/undisguiseplayer ".@plr)
        die()
    }
    
    @forgottenHeroes = import('forgottenHeroes')
    if(@forgottenHeroes != null){
        foreach(@fhero in @forgottenHeroes){
            if(@fhero == @class){
                sudo('/mainmenu')
                set_timeout(3000,closure(
                    msg(color('RED').'Sorry, that hero is currently locked. Please check back later.')
                ))
                die()
            }
        }
    }
    if(!array_index_exists(@hero,'allowMultiple') || @hero['allowMultiple'] != true){    
        @alts = ''
        if(array_index_exists(@hero,'alts')){
            @alts = @hero['alts']
        }
        foreach(@player in @plrs)
        {
            @otherPlayerGroup = _getheroclass(@player)
            if(@otherPlayerGroup == @hero['class'] && @plr != @player && @hero['class'] != 'mortal'){
                set_timeout(1500, closure(
                    runas(@plr,'/mainmenu')
                    broadcast(color('WHITE')  . @plr . color('GRAY') . " has been returned to the main menu because " . color('WHITE') . @player . color('GRAY') . " was already " . @hero['name'])
                ))
                die()
            }
            if(is_array(@alts)){
                foreach(@alt in @alts){
                    if(@alt == @otherPlayerGroup){
                        set_timeout(1500, closure(
                            runas(@plr,'/mainmenu')
                            @h1 = @hero['name']
                            @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@alt.'.yml')
                            @hero = yml_decode(@contents)
                            @h2 = @hero['name']
                            msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                            msg(color('RED').'Sorry, '.color('WHITE').@player.color('RED').' is already using '.@h2.color('RED').'.')
                            msg(color('RED').'Try again with:')
                            msg(color('GREEN').'/characterselect')
                            msg(color('YELLOW').'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                        ))
                        die()
                    }
                }
            }
        }
    }

//    if(has_permission(@plr,'tick.kill')){
 //       runas('~console','/stoptorture')
  //      runas('~console','/torture '.@plr.' 50')
   // }

    if(has_permission(@plr,'arrest.onjoin')){
        runas('~console','/arrest '.@plr.' Joining Auto-Arrest Bot v2.1b')
        runas('~console','/pex user '.@plr.' remove arrest.onjoin')
    }

    sudo('/ch set '.@plr.' global')
    set_timeout(5000, closure(
        if(@class == 'mortal' && has_permission(@plr,'is.ingame')){
            sudo('/mainmenu')
            die()
        }
    ))
    set_timeout(5000, closure(
        _changeSkin(@plr,@hero['sig'],@hero['val'],@hero['name'])
        _changeTrail(@plr, @hero['trail'])
    ))

}
