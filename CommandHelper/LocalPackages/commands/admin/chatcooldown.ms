register_command('addchatcooldown', 
    array(
        'description': 'Adds a cooldown timer to a players chat. Helps with spammers',
        'usage': '/addchatcooldown <player>',
        'permission': 'ch.alias.addchatcooldown',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'aliases': 'addchattimer',
    
        'executor': closure(@alias, @sender, @args) {
        
                if (array_size(@args) != 1) {
                
                    msg(color('RED').color('BOLD').'Improper Usage!');
                    msg(color('RED').'Usage: /addchatcooldown <player>');
                    die(); # No need to go further					
                
                }
                
                try {
                    @plr = player(@args[0])
                    @player = player()
                    
                    sudo("/pex user ".@plr." add chat.cooldown")
                    tmsg(@plr,color('RED').'You have been given a chat cooldown by '.@player.' for spamming!')
                    tmsg(@player,color('RED').'You have given '.@plr.' a chat cooldown!')	
                } catch (PlayerOfflineException @ErrorInfo) {				
                    msg(@player,'Player: '.@plr.' is Offline')
                    die()
                }				
                
                            
        
        }
    )
)

register_command('remchatcooldown', 
    array(
        'description': 'Removes a cooldown timer from a player',
        'usage': '/remchatcooldown <player>',
        'permission': 'ch.alias.remchatcooldown',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'aliases': 'remchattimer',
        
        'executor': closure(@alias, @sender, @args) {
        
                if (array_size(@args) != 1) {
                
                    msg(color('RED').color('BOLD').'Improper Usage!');
                    msg(color('RED').'Usage: /addchatcooldown <player>');
                    die(); # No need to go further					
                
                }				
                
                try {
                    @plr = player(@args[0])
                    @player = player()
                    
                    sudo("/pex user ".@plr." remove chat.cooldown")
                    tmsg(@plr,color('RED').'Your chat cooldown has been removed by '.@player.'!')
                    tmsg(@player,color('RED').'You have remove the chat cooldown for '.@plr.'!')
                } catch (PlayerOfflineException @ErrorInfo) {				
                    msg(@player,'Player: '.@plr.' is Offline')
                    die()
                }
                
        
        }
    )
)
