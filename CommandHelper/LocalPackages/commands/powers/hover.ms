register_command('hover', 
    array(
        'description': 'Power',
        'permission': 'ch.alias.hoveron',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /hover <on/off>');
                die(); # No need to go further					
            
            }
            
            @status = @args[0]
            
            if (@status == 'on') {
            
                sudo(/effect player() 25 9999 255 true)
                tmsg(player(),concat(color('GOLD'),
                'You feel lighter than a feather..'))
                
            } else if (@status == 'off') {
            
                sudo(/effect player() 25 0)
                tmsg(player(),concat(color('GOLD'),
                'Your gravity returns.'))
            
            } else {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /hover <on/off>');
                die(); # No need to go further	
            
            }
            
        }
    )
)