register_command('throwfeather', 
    array(
        'description': 'Power',
        'permission': 'powers.throwfeather',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure() {        
            
            @player = player()
            @pcursor = pcursor(@player)

            @feather = shoot_projectile(@player,'ARROW',@pcursor,2.0)

            @featherVelocity = entity_velocity(@feather)
            @featherLocation = entity_loc(@feather)

            entity_remove(@feather)
            @feath = drop_item(@featherLocation,array('type':'267','meta':array('display': color('GREY').'Iron Feather')),false)
            set_entity_velocity(@feath,@featherVelocity)

            export(@player.'archAngelFeather',@feath)
            export(@player.'archAngelFeatherPos',array('x':'','y':'','z':''))

            set_interval(50,closure(
                @feath = import(@player.'archAngelFeather')
                @oldPos = import(@player.'archAngelFeatherPos')
                try{
                    @newPos = entity_loc(@feath)
                }catch(Exception @e){
                    clear_task()
                }
                if(
                    @oldPos['x'] == @newPos['x'] &&
                    @oldPos['z'] == @newPos['z']
                ){
                    clear_task()
                }else{
                    @plrs = entities_in_radius(@newPos,2)
                    foreach(@plr in @plrs){
                        if(is_entity_living(@plr)){
                            damage_entity(puuid(@plr), 10, puuid(@player));
                        }
                    }
                    export(@player.'archAngelFeatherPos',@newPos)
                }
            ))

        }
    )
)