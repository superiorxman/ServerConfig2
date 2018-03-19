register_command('speak', 
    array(
        'description': 'Power',
        'permission': 'ch.alias.speak',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
            if (array_size(@args) < 2) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /speak <player> <some sort of message>');
                die()
            }
            
            @vic = @args[0]
            @vic = player(@vic)
            
            if(!has_permission(@vic,'is.ingame')){
                msg(color('RED').color('BOLD').'Sorry, that player is not in the game.');
                die()
            }

            @msg = ''
            for (@i=1, @i < array_size(@args), @i++){            
                @msg = @msg.' '.@args[@i]
            }
            
            @msg = trim(@msg)
            chatas(@vic,'.'.@msg)
            
            @players = all_players()
            foreach (@player in @players){
                if (has_permission(@player, 'is.police')){
                    tmsg(@player, color('GRAY').color('ITALIC').'*Player Speaking*: '.@sender)
                }
            }
            
        }
    )
)

