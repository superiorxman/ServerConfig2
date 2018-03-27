register_command('jhi', 
    array(
        'description': 'Power',
        'permission': 'powers.jhi',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 0) {
                tmsg(@sender,color('RED').'USAGE: /jhi')
                return(false)
            }

            @oldJhi = import('jhi')
            if(@oldJhi != null){
                foreach(@jhi in @oldJhi){
                    try{
                        entity_remove(@jhi)
                        tmsg(@sender,color('RED').'Jhi has been returned to you')
                        export('jhi',null)
                        die()
                    }catch(Exception @e){
                        continue()
                    }
                }
            }

            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown('jhi',1,@sender)){
                return()
            }

            @jhiUUID = spawn_mob('wolf:tamed',1)
            export('jhi',@jhiUUID)
            set_timeout(50,closure(
                tame_mob(@sender,@jhiUUID[0])
                runas('~console',"/disguiseplayer ".@jhiUUID[0].' polarbear')
                tmsg(@sender,color('RED').'Jhi has been summoned')
            ))
            
        }
    )
)
