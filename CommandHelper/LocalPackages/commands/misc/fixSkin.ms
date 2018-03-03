register_command('fixskin', 

    array(
        'description': 'Fix a Players Skin',
        'usage': '/fixskin [player]',
        'permission': 'ch.alias.fixskin',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) > 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /fixskin [player]');
                die(); # No need to go further					
            
            }
            
            include('/home/minecraft/server/plugins/CommandHelper/includes/changeSkin.ms')
            
            if (array_size(@args) == 1) {
            
                try {
                    @plr = player(@args[0])
                    include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                    @class = _getheroclass(@player)
                    
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                    @hero = yml_decode(@contents)
                    _changeSkin(@plr,@hero['sig'],@hero['val'],@hero['name'])
                    
                } catch (PlayerOfflineException @ErrorInfo) {				
                    msg(@player,'Player: '.@plr.' is Offline')
                    die()
                } catch (IOException @ErrorInfo) {
                
                }
                
            } else {
            
                try {
                    @plr = player()
                    include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                    @class = _getheroclass(@plr)
                    
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                    @hero = yml_decode(@contents)
                    _changeSkin(@plr,@hero['sig'],@hero['val'],@hero['name'])
                    
                } catch (PlayerOfflineException @ErrorInfo) {				
                    msg(@player,'Player: '.@plr.' is Offline')
                    die()
                } catch (IOException @ErrorInfo) {
                    
                }		
            
            }        
        }
    )
)
