register_command('speak', 
    array(
        'description': 'Power',
        'permission': 'ch.alias.speak',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) < 2) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /speak <player> <msg>');
                die(); # No need to go further					
            
            }
            
            @msg = ''
            @plr = @args[0]
            @plrSpeaking = player()
            
            for (@i=1, @i < array_size(@args), @i++){
            
                @msg = @msg.' '.@args[@i]
            
            }
            
            @msg = trim(@msg)
            
            sudo('/sudo '.@plr.' c:.'.@msg)
            
            @players = all_players()
            
            foreach (@player in @players){
                if (has_permission(@player, 'is.officer')){
                    tmsg(@player, color('GRAY').color('ITALIC').'*Player Speaking*: '.@plrSpeaking)
                }
            }
            
        }
    )
)

