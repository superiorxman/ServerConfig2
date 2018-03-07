register_command('mindcontrol', 

    array(
        'description': 'Mind Controls a person',
        'permission': 'ch.alias.mindcontrol',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {

            if (array_size(@args) != 1) {
                return(false)
            }
            
            @player = player()
    
            @vic = @args[0]
            if(@vic == '@t'){
                die()
            }
            @vic = player(@vic)

            export(@player.'mindControlVictim',@vic)

            if(@player == @vic){
                msg(color('RED').'You are already mindcontrolling yourself!')
                die()
            }

            if(has_permission(@vic,"is.telepathicallyresistant")){
                tmsg(@player,color('RED')."Sorry, that player is telepathically resistant.")
                die()
            }

            if(has_permission(@vic,"is.criminal")){
                tmsg(@player,color('RED')."Sorry, that player cannot be controlled.")
                die()
            }

            if(import(@vic.'beingMindControlled') == true){
                msg(color('RED').'Sorry, that person is already being mind controlled')
                die()
            }
            if(import(@vic.'mindControlling') == true){
                msg(color('RED').'Sorry, that person is already mind controlling someone')
                die()
            }

            if(!has_permission(@vic,'is.mindControllable')){
                msg(color('RED').'Sorry, that person is in a minigame or other protected area')
                die()
            }

            @id = get_claim_id(ploc(@vic))
            if(@id != null){
                msg(color('RED').'Sorry, that person is in a minigame or other protected area')
                die()
            }

            @ploc = ploc(@player)
            @vloc = ploc(@vic)
            
            if(@ploc['world'] != @vloc['world']){
                tmsg(@player,color('RED').'Sorry, you need to be in the same world to do that.')
                die()        
            }

            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @pClass = _getheroclass(@player)

            @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@pClass.'.yml')
            @pHero = yml_decode(@contents)

            if(array_index_exists(@pHero,'mindControlLimit')){
                @radius = @pHero['mindControlLimit']
                @dist = distance(@ploc,@vloc)
                if(@dist > @radius){
                    tmsg(@player,color('RED').'Sorry, you are not close enough to that person. Please get within '.@radius.' blocks.')
                    die()
                }
            }

            // actual mind control begins here
            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            _coolDown('lastUsedMindControl',60,@player)

            // summon villager at point of mind controller so players may damage his body
            @ploc['y'] += 1
            @markerUUID = spawn_entity('VILLAGER',1,@ploc)[0]
            @puuid = puuid(@player)
            if(@markerUUID != null){
                runas('~console',"/disguiseplayer ".@markerUUID.' player '.@player.' setskin {"id":"87fb3c6c5ff64bf6b326992c6137ea12","name":"tektronic","properties":[{"signature":"'.@pHero['sig'].'","name":"textures","value":"'.@pHero['val'].'"}]}')
                set_mob_name(@markerUUID,@player)
                export(@player.'mindControlEntityID',@markerUUID)
                // forward all damage to villager to mindcontroller at 10x the amount
                bind('entity_damage',array('id':@player.'mindControlEntityDamaged'),array('id':@markerUUID),@e,@idd = @puuid,@playerr = @player){
                    cancel()
                    if(array_index_exists(@e,'damager') && @e['damager'] != @playerr){
                        damage_entity(@idd,(@e['amount']*10))
                        tmsg(@playerr,'Your body is being damaged!')
                    }
                }
            }else{
                tmsg(@player,color('RED').'Sorry, you are in a protected location, you cannot mind control from here.')
                _coolDown('lastUsedMindControl',1,@player)
                die()
            }
            
            // get victims info
            @vClass = _getheroclass(@vic)
            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@vClass.'.yml')
                @vHero = yml_decode(@contents)
            }catch(Exception @e){
                @vHero = array('name':@player)
            }

            //makes it so no one can change into the mindcontroller person while they change classes
            @existingForgottenHeroes = import('forgottenHeroes')
            if(@existingForgottenHeroes == null || @existingForgottenHeroes == ''){
                @existingForgottenHeroes = @pClass
            }else if(is_array(@existingForgottenHeroes)){
                array_push(@existingForgottenHeroes,@pClass)
            }else{
                @existingForgottenHeroes = array(@existingForgottenHeroes,@pClass)
            }
            export('forgottenHeroes',@existingForgottenHeroes)

            @vInv = pinv(@vic)
            @pInv = pinv(@player)
            export(@player.'mindControlPlayerInv',@pInv)
            export(@player.'mindControlPlayerOrigHero',@pClass)
            export(@player.'mindControlVicOrigHero',@vClass)
            export(@player.'mindControlPlayerOrigLocation',@ploc)
            export(@player.'mindControlVicOrigGameMode',pmode(@vic))
            export(@player.'mindControlling',true)
            export(@vic.'beingMindControlled',true)

            set_ploc(@player,@vloc)
            set_pmode(@vic,'SPECTATOR')
            set_pspectator_target(@vic,@puuid)

            runas('~console','/pex user '.@player.' group set '.@vClass)
            if(array_index_exists(@vHero,'sig')){
                runas('~console',"/disguiseplayer " . @player . ' player ' . @vic . ' setskin {"id":"87fb3c6c5ff64bf6b326992c6137ea12","name":"tektronic","properties":[{"signature":"'.@vHero['sig'].'","name":"textures","value":"'.@vHero['val'].'"}]}')
            }else{
                sudo('/disguise player '.@vic)
            }

            set_pinv(@player,@vInv)
            sudo('/buff')

            bind('player_death',array('id':@player.'mindControlDeath'),array('player':@player),@e,@playerr = @player){
                include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
                _mindControlStop(@playerr)
            }
            bind('player_command',array('id':@vic.'mindControlCommandCancel'),array('player':@vic),@e,@vicc = @vic){
                cancel()
                tmsg(@vicc,color('RED').'You are being mind controlled, you can\'t use any commands right now!')
            }
            bind('player_chat',associative_array('id': @player.'mindControlChatForward'),associative_array('player': @player),@event, @playerr = @player, @vicc = @vic){
                cancel()
                console('chat forwarded from '.@playerr. ' to '.@vicc)
                chatas(@vicc,@event['message'])
                @players = all_players()
                foreach (@plor in @players){
                    if (has_permission(@plor, 'is.officer')){
                        tmsg(@plor, color('GRAY').color('ITALIC').'*MindController*: '.@playerr)
                    }
                }
            }
            bind('player_quit', associative_array('id': @player.'mindControlVicLeave'), associative_array('player': @vic), @event, @playerr = @player, @vicc = @vic){
                runas('~console','/tempban '.@vicc.' 60s 1 Minute Ban For Quitting During Mind Control')
                runas('~console','/pex user '.@vicc.' group set mortal')
                include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
                _mindControlStop(@playerr)
            }
            bind('player_quit',associative_array('id': @player.'mindControlPlrLeave'),associative_array('player': @player),@event, @playerr = @player){
                include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
                _mindControlStop(@playerr)
            }

            // end the mind control after 30 seconds
            @mindControlTimer = set_timeout(30000,closure(
                include('/home/minecraft/server/plugins/CommandHelper/includes/mindControlStop.ms')
                _mindControlStop(@player)
            ))
            export(@player.'mindControlTimer',@mindControlTimer)
            runas('~console','/pex user '.@player.' timed add ch.alias.stopmindcontrol 30 superherocity')
            broadcast(@player." is now mindcontrolling ".@vic)
        }
    )
)

register_command('stopmindcontrol', 

    array(
        'description': 'Stops mind control',
        'permission': 'ch.alias.stopmindcontrol',
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
