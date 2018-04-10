register_command('multimindcontrol', 

    array(
        'description': 'Mind Controls a person',
        'permission': 'ch.alias.multimindcontrol',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {

            if (array_size(@args) <= 0) {
                return(false)
            }
            
            @player = @sender
            
            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('lastUsedMultiMindControl',60,@player,true)){
                return()
            }

            @vics = @args
            @numSuccesses = 0
            @ploc = ploc(@player)
            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')

            foreach(@vic in @args){
                if(@player == @vic){
                    msg(color('RED').'You are already mindcontrolling yourself!')
                    die()
                }

                if(has_permission(@vic,"is.telepathicallyresistant")){
                    tmsg(@player,color('RED').'Sorry, '.@vic.' is telepathically resistant.')
                    die()
                }

                if(has_permission(@vic,"is.criminal")){
                    tmsg(@player,color('RED').'Sorry, '.@vic.' cannot be controlled.')
                    die()
                }

                if(import(@vic.'beingMindControlled') == true){
                    msg(color('RED').'Sorry, '.@vic.' is already being mind controlled')
                    die()
                }
                if(import(@vic.'mindControlling') == true){
                    msg(color('RED').'Sorry, '.@vic.' is already mind controlling someone')
                    die()
                }

                if(!has_permission(@vic,'is.mindControllable')){
                    msg(color('RED').'Sorry, '.@vic.' is in a minigame or other protected area')
                    die()
                }

                if(sk_region_check_flag(ploc(@vic),'invincible',@vic) == true){
                    tmsg(@player,color('RED').'Sorry, '.@vic.' is in a protected area.')
                    die()
                }

                @id = get_claim_id(ploc(@vic))
                if(@id != null){
                    msg(color('RED').'Sorry, '.@vic.' is in a minigame or other protected area')
                    die()
                }

                
                @vloc = ploc(@vic)
                
                if(@ploc['world'] != @vloc['world']){
                    tmsg(@player,color('RED').'Sorry, '.@vic.' is in a different world.')
                    die()       
                }   

                
                // get victims info
                @vClass = _getheroclass(@vic)
                try{
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@vClass.'.yml')
                    @vHero = yml_decode(@contents)
                }catch(Exception @e){
                    @vHero = null
                }

                // summon villager at point of mind controller so players may damage his body
                @vloc['y'] += 1
                @markerUUID = spawn_entity('VILLAGER',1,@vloc)[0]
                if(@markerUUID != null){
                    if(@vHero == null){
                        runas('~console',"/disguiseplayer ".@markerUUID.' player '.@vic)
                    }else{
                        runas('~console',"/disguiseplayer ".@markerUUID.' player '.@vic.' setskin {"id":"87fb3c6c5ff64bf6b326992c6137ea12","name":"tektronic","properties":[{"signature":"'.@vHero['costumes'][0]['sig'].'","name":"textures","value":"'.@vHero['costumes'][0]['val'].'"}]}')
                    }
                    set_mob_name(@markerUUID,@vic)
                    // forward all damage from villager to vic at 10x
                    @vuuid = puuid(@vic)
                    bind('entity_damage',array('id':@vic.'mindControlEntityDamaged'),array('id':@markerUUID),@e,@vuuid,@vic){
                        cancel()
                        if(array_index_exists(@e,'damager') && @e['damager'] != @vic){
                            damage_entity(@vuuid,(@e['amount']*10))
                            tmsg(@vic,'Your body is being damaged!')
                        }
                    }
                }else{
                    tmsg(@player,color('RED').'Sorry, '.@vic.' is in a protected location, you cannot mind control there.')
                    continue()
                }

                @existingForgottenHeroes = import('forgottenHeroes')
                
                bind('player_command',array('id':@vic.'mindControlVicCommandCancel'),array('player':@vic),@e, @vic){
                    cancel()
                    tmsg(@vic,color('RED').'You are being mind controlled, you can\'t use any commands right now!')
                }
                bind('player_quit', array('id': @vic.'mindControlVicLeave'), array('player': @vic), @event, @vic){
                    runas('~console','/tempban '.@vic.' 60s 1 Minute Ban For Quitting During Mind Control')
                    runas('~console','/pex user '.@vic.' group set mortal')
                    include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
                    _mindControlStopPlayer(@vic)
                }
                bind('player_death',array('id':@vic.'mindControlVicDeath'),array('player':@vic),@e,@vic){
                    include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
                    _mindControlStopPlayer(@vic)
                }

                @timer = set_timeout(30000,closure(
                    _mindControlStopPlayer(@vic)
                ))
                export(@vic.'mindControlTimer',@timer)
                export(@player.'mindControlVicOrigHero',@vClass)
                export(@vic.'beingMindControlled',true)
                export(@vic.'beingMindControlledBy',@player)
                export(@vic.'markerUUID',@markerUUID)
                export(@vic.'mindControlVicOrigGameMode',pmode(@vic))

                set_pmode(@vic,'SPECTATOR')
                set_pspectator_target(@vic,@markerUUID)

                @temp = array(@vic,@markerUUID)
                array_push(@successfulVics,@temp)
                @numSuccesses++
                
            }
            if(@numSuccesses > 0){
                if(_coolDown('lastUsedMultiMindControl',60,@player)){
                    return()
                }

                bind('player_quit',array('id': @player.'mindControlPlrLeave'),array('player': @player),@event, @player){
                    include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
                    _mindControlStopPlayers(@player)
                }
                bind('player_death',array('id':@player.'mindControlPlrDeath'),array('player':@player),@e,@player){
                    include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
                    _mindControlStopPlayers(@player)
                }
                
                @pClass = _getheroclass(@player)
                export(@player.'mindControlPlayerOrigLocation',@ploc)
                export(@player.'mindControlPlayerOrigHero',@pClass)
            }
        }
    )
)

register_command('stopmultimindcontrol', 

    array(
        'description': 'Stops mind control',
        'permission': 'ch.alias.stopmultimindcontrol',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {        
            
            @player = @sender
            assign(@cooldown, 30)
            
            assign(@lastUsedStopMindControl, import(@player."lastUsedStopMindControl"))
            if(@lastUsedStopMindControl + @cooldown > time() / 1000,
                assign(@timeleft, subtract(add(@lastUsedStopMindControl, @cooldown), divide(time(),1000)))
                tmsg(@player,concat('§c[§4', Error, '§c] §7You must wait another §6', round(@timeleft), ' §7seconds before you can stop mind control again!'))
                die()
            )
            export(@player."lastUsedStopMindControl", time() / 1000)

            if(import(@player.'mindControlling') != true){
                msg(color('RED').'Sorry, you are not currently mind controlling anyone')
                die()
            }

            include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
            _mindControlStop(@player)
            
            
        }
    )
)
