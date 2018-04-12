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
            @vic = @args[0]
            @vic

            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @pClass = _getheroclass(@player)
            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@pClass.'.yml')
                @pHero = yml_decode(@contents)
            }catch(Exception @e){
                @pHero = array('timeStopDuration': 10, 'timeStopCooldown': 10, 'timeStopDist':99999999)
            }
            
            
            @dist = distance(ploc(@player),ploc(@vic))

            if(@dist > @pHero['timeStopDist']){
                tmsg(@player,color('RED').'Sorry, please get within '.@pHero['timeStopDist'].' blocks')
                die()
            }

            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('lastUsedTimeStop',@pHero['timeStopCooldown'],@player) ){
                return()
            }
            @inv = pinv(@vic)
            clear_pinv(@vic)
            sudo('/freeze '.@vic.' '.(@pHero['timeStopDuration'] * 1000))
            tmsg(@player,color('RED').'You froze '.@vic.' in time.')
            tmsg(@vic,color('RED').'You are frozen in time')

            @commandBind = bind('player_command',null,array('player':@vic),@e){
                cancel()
                tmsg(@e['player'],color('RED').'You cannot use commands while frozen in time')
            }

            @chatBind = bind('player_chat',null,array('player':@vic),@e){
                cancel()
                tmsg(@e['player'],color('RED').'You cannot speak while frozen in time')
            }

            set_timeout(@pHero['timeStopDuration'] * 1000 ,closure(
                set_pinv(@vic,@inv)
                unbind(@chatBind)
                unbind(@commandBind)
                tmsg(@vic,color('RED').'You are free from timestop')
            ))
                
        }
    )
)
