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
            
            if (array_size(@args) == 1) {
            
                @plr = @args[0]
                @plr = player(@plr)
                @skinNum = import(@plr.'skinNum')
                if(@skinNum != null){
                    sudo('/skin '.@skinNum)
                    die()
                }else{
                    queue_push(closure(runas('~console','/undisguiseplayer '.@plr)))
                    queue_push(closure(sudo('/skin 1')))
                }
                
            } else {
                @plr = @sender
                @skinNum = import(@plr.'skinNum')
                console('SKIN NUM ISSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS '.@skinNum)
                if(@skinNum != null){
                    sudo('/skin '.@skinNum)
                    die()
                }else{
                    queue_push(closure(runas('~console','/undisguiseplayer '.@plr)))
                    queue_push(closure(sudo('/skin 1')))
                }
            }        
        }
    )
)
