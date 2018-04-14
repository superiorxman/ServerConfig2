register_command('mindcontrol', 

    array(
        'description': 'Mind Controls a person',
        'permission': 'powers.mindcontrol',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {

            if (array_size(@args) <= 0) {
                return(false)
            }
            
            @player = @sender
            
            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('lastUsedMindControl',60,@player,true)){
                return()
            }

            @vics = @args
            @numSuccesses = 0
            @ploc = ploc(@player)
            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @pClass = _getheroclass(@player)
            @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@pClass.'.yml')
            @pHero = yml_decode(@contents)
            @maxVics = 1
            if(array_index_exists(@pHero,'maxVics')){
               @maxVics = @pHero['maxVics'] 
            }
            @successfulVics = array()
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
                include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
                bind('player_command',array('id':@vic.'mindControlVicCommandCancel'),array('player':@vic),@e, @vic){
                    cancel()
                    tmsg(@vic,color('RED').'You are being mind controlled, you can\'t use any commands right now!')
                }
                bind('player_quit', array('id': @vic.'mindControlVicLeave'), array('player': @vic), @event, @vic){
                    runas('~console','/pex user '.@vic.' group set mortal')
                    runas('~console','/tempban '.@vic.' 60s 1 Minute Ban For Quitting During Mind Control')
                    _mindControlStopPlayer(@vic)
                }
                bind('player_death',array('id':@vic.'mindControlVicDeath'),array('player':@vic),@e,@vic){
                    _mindControlStopPlayer(@vic)
                }

                export(@vic.'beingMindControlled',true)
                export(@vic.'beingMindControlledBy',@player)
                export(@vic.'mindControlOrigHero',@vClass)
                export(@vic.'markerUUID',@markerUUID)
                export(@vic.'mindControlOrigGameMode',pmode(@vic))
                export(@vic.'mindControlInventory',pinv(@vic))

                set_pmode(@vic,'SPECTATOR')
                set_pspectator_target(@vic,@markerUUID)

                array_push(@successfulVics,@vic)
                @numSuccesses++
                if(@numSuccesses == @maxVics){
                    set_timeout(1000,closure(
                        sudo('/mindcontrolswitch '.@vic)
                    ))
                    break()
                }
                
            }
            if(@numSuccesses > 0){
                if(_coolDown('lastUsedMindControl',60,@player)){
                    return()
                }

                bind('player_quit',array('id': @player.'mindControlPlrLeave'),array('player': @player),@event, @player){
                    _mindControlStopPlayer(@player)
                }
                bind('player_death',array('id':@player.'mindControlPlrDeath'),array('player':@player),@e,@player){
                    _mindControlStopPlayer(@player)
                }

                export(@player.'mindControlOrigHero',@pClass)
                export(@player.'mindControlVics',@successfulVics)
                export(@player.'mindControlInventory',pinv(@player))
                export(@player.'mindControlling',true)
                runas('~console','/pex user '.@player.' timed add powers.mindcontrol 30 superherocity')
                @timer = set_timeout(30000,closure(
                    _mindControlStop(@player)
                ))
                export(@player.'mindControlTimer',@timer)
            }
        }
    )
)

register_command('stopmindcontrol', 

    array(
        'description': 'Stops mind control',
        'permission': 'powers.mindcontrol',
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

register_command('mindcontrolswitch', 

    array(
        'description': 'Switches mind control',
        'permission': 'powers.mindcontrol',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {        
            
            if(array_size(@args) != 1){
                tmsg(@sender,color('RED').'Usage: /mindcontrolswitch <player>')
                die()
            }

            @player = @sender

            @vic = import(@player.'mindControlActiveVic')
            if(@vic != null){
                @pInv = pinv(@player)
                export(@vic.'mindControlInventory',@pInv)
                @vClass = import(@vic.'mindControlOrigHero')
                try{
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@vClass.'.yml')
                    @vHero = yml_decode(@contents)
                }catch(Exception @e){
                    @vHero = null
                }

                @ploc = ploc(@player)
                @ploc['y'] += 1
                @markerUUID = spawn_entity('VILLAGER',1,@ploc)[0]
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
                        if(array_index_exists(@e,'damager')){
                            damage_entity(@vuuid,(@e['amount']*10))
                            tmsg(@vic,'Your body is being damaged!')
                        }
                    }
                }else{
                    tmsg(@player,color('RED').'Sorry, '.@vic.' is in a protected location, you cannot mind control there.')
                    die()
                }
                export(@vic.'markerUUID',@markerUUID)
            }else{
                @ploc = ploc(@player)
                @ploc['y'] += 1
                @pClass = import(@player.'mindControlOrigHero')
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@pClass.'.yml')
                @pHero = yml_decode(@contents)
                @markerUUID = spawn_entity('VILLAGER',1,@ploc)[0]
                if(@markerUUID != null){
                    runas('~console',"/disguiseplayer ".@markerUUID.' player '.@player.' setskin {"id":"87fb3c6c5ff64bf6b326992c6137ea12","name":"tektronic","properties":[{"signature":"'.@pHero['costumes'][0]['sig'].'","name":"textures","value":"'.@pHero['costumes'][0]['val'].'"}]}')
                    set_mob_name(@markerUUID,@player)
                    // forward all damage from villager to vic at 10x
                    @puuid = puuid(@player)
                    bind('entity_damage',array('id':@player.'mindControlEntityDamaged'),array('id':@markerUUID),@e,@puuid,@player){
                        cancel()
                        if(array_index_exists(@e,'damager')){
                            damage_entity(@puuid,(@e['amount']*10))
                            tmsg(@player,'Your body is being damaged!')
                        }
                    }
                }
                export(@player.'markerUUID',@markerUUID)
            }

            @vic = @args[0]
            @vic = player(@vic)
            @vClass = import(@vic.'mindControlOrigHero')

            if(import(@vic.'beingMindControlled') !=  true){
                tmsg(@sender.color('RED').'You need to be mindcontrolling them first!')
                die()
            }
            
            @vInv = import(@vic.'mindControlInventory')
            set_pinv(@player,@vInv)

            @vicMarkerUUID = import(@vic.'markerUUID')
            @markerLoc = entity_loc(@vicMarkerUUID)
            set_ploc(@player,@markerLoc)
            set_pspectator_target(@vic,puuid(@player))
            entity_remove(@vicMarkerUUID)
            if(has_bind(@vic.'mindControlEntityDamaged')){
                unbind(@vic.'mindControlEntityDamaged')
            }
            
            runas('~console','/pex user '.@player.' group set '.@vClass)
            runas('~console','/sudo '.@player.' c:/effects')
            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@vClass.'.yml')
                @vHero = yml_decode(@contents)
            }catch(Exception @e){
                @vHero = null
            }
            if(@vHero == null){
                runas('~console',"/disguiseplayer ".@player.' player '.@vic)
            }else{
                runas('~console',"/disguiseplayer ".@player.' player '.@vic.' setskin {"id":"87fb3c6c5ff64bf6b326992c6137ea12","name":"tektronic","properties":[{"signature":"'.@vHero['costumes'][0]['sig'].'","name":"textures","value":"'.@vHero['costumes'][0]['val'].'"}]}')
            }

            if(has_bind(@player.'mindControlChatForward')){
                unbind(@player.'mindControlChatForward')
            }
            bind('player_chat',array('id':@player.'mindControlChatForward'),array('player':@player),@e, @vic,@player){
                chatas(@vic,@e['message'])
            }

            export(@player.'mindControlActiveVic',@vic)
            
        }
    )
)
