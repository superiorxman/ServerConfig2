register_command('confuse', 
    array(
        'description': 'Confuse a player',
        'permission': 'ch.alias.confuse',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /confuse <player>');
                die(); # No need to go further					
            
            }
            
            @player = player()
            @victim = @args[0]
            if(has_permission(@victim,"is.awesome")){
                tmsg(@player,color('RED')."Sorry, that player cannot be confused.")
                die()
            }
            if(has_permission(@victim,"is.telepathicallyresistant")){
                tmsg(@player,color('RED')."Sorry, that player is telepathically resistant.")
                die()
            }
            
            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('confuse',30,@player)){
                return()
            }
            
            if(ponline(@victim)){
                export(@victim."isConfused", "true")
                broadcast(color('BLUE') . @player . color('GRAY') . " is using their mind control to confuse " . color('BLUE') . @victim . color('GRAY') . "!")
            
                set_timeout(30000, closure(
            
                    broadcast(color('BLUE') . @victim . color('GRAY') . " is no longer confused.")
                    export(@victim."isConfused", "false")
            
                ))
            }
                
        }
    )
)

register_command('unconfuse', 
    array(
        'description': 'Unconfuse a player',
        'permission': 'ch.alias.unconfuse',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /unconfuse <player>');
                die(); # No need to go further					
            
            }
            
            @player = player()
            @victim = @args[0]
            
            if(is_null(import(@player."usedUnConfuse"))){
                export(@player."usedUnConfuse", 0)
            }
            
            assign(@cooldown, 30)
            
            assign(@lastUnConfuse, import(@player."usedUnConfuse"))
            if(@lastUnConfuse + @cooldown > time() / 1000,
                die(color('RED')."You must cool down before you can unconfuse anyone again!")
            )
            export(@player."usedUnConfuse", time() / 1000)
            
            
            if(ponline(@victim)){
                export(@victim."isConfused", "false")
                broadcast(color('BLUE') . @victim . color('GRAY') . " is no longer confused.")
            }
                
        }
    )
)
