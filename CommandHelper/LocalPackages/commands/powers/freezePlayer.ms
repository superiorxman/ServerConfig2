register_command('timestop', 
    array(
        'description': 'Power',
        'permission': 'powers.timestop',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
                return(false)
            }
            
            @player = player()
            @plr = @args[0]
            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('lastUsedForcePush',60,@player) ){
                return()
            }
            
            @dist = distance(ploc(@player),ploc(@plr))

            if(@dist > 20){
                tmsg(@player,color('RED').'Sorry, they are not close enough')
                die()
            }

            sudo('/freeze '.@plr.' 20000')
            tmsg(@player,color('RED').'You froze '.@plr.' in time.')
            tmsg(@plr,color('RED').'You are frozen in time')

            @commandBind = bind('player_command',null,array('player':@plr),@e){
                cancel()
                tmsg(@e['player'],color('RED').'You cannot use commands while frozen in time')
            }

            @chatBind = bind('player_chat',null,array('player':@plr),@e){
                cancel()
                tmsg(@e['player'],color('RED').'You cannot speak while frozen in time')
            }

            set_timeout(20000,closure(
                unbind(@chatBind)
                unbind(@commandBind)
                tmsg(@plr,color('RED').'You are free from timestop')
            ))
                
        }
    )
)
