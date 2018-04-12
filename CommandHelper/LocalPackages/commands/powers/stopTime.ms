/*register_command('stoptime', 
    array(
        'description': 'Power',
        'permission': 'powers.stoptime',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {        
            
            @player = @sender
            @vic = @args[0]
            @vic = player(@vic)
            
            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            _coolDown('lastUsedStopTime',@player,30000)

            sudo('/freezeplayer '.@player.' 10')
                
        }
    )
)
*/