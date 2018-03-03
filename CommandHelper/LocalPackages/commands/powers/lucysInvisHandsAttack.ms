register_command('invishandsattack', 
    array(
        'description': 'Power',
        'permission': 'ch.alias.invishandsattack',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /invishandsattack <player>');
                die(); # No need to go further					
            
            }
            
            @vic = @args[0]
            @vic = player(@vic)
            @plr = player()
            @ploc = ploc(@plr)

            if(ponline(@vic)){
                @plrs = players_in_radius(@ploc,10)
                foreach(@player in @plrs){
                    if(@vic == @player){
                        damage_entity(puuid(@vic),40,puuid(@plr))
                    }else{
                        tmsg(@plr,color('RED').'You are not close enough to that player!')
                    }
                }   
            }
            
        }
    )
)
