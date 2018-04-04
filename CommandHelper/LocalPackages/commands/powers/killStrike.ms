register_command('killstrike', 
    array(
        'description': 'Power',
        'permission': 'powers.killstrike',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
                return(false)
            }
            
            @player = player()
            @plr = @args[0]
            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('lastUsedForcePush',10,@player) ){
                return()
            }
            
            @dist = distance(ploc(@player),ploc(@plr))

            if(@dist > 3){
                tmsg(@player,color('RED').'Sorry, they are not close enough')
                die()
            }

            pkill(@plr)
            broadcast(color('RED').'Hit assassinates another target.')
                
        }
    )
)
