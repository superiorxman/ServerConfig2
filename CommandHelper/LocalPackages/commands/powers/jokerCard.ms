register_command('jokercard', 
    array(
        'description': 'Give yourself a jokercard',
        'permission': 'ch.alias.jokercard',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure() {        
            
            @magnitude = 2;
            @damage = 50;

            @loc = ploc();
            @loc['y'] += 2;

            @yaw = @loc['yaw'] + 90;
            @pitch = neg(@loc['pitch']);
            @vector = associative_array();
            @vector['x'] = @magnitude * (cos(to_radians(@yaw)) * cos(to_radians(@pitch)));
            @vector['y'] = @magnitude * sin(to_radians(@pitch));
            @vector['z'] = @magnitude * (sin(to_radians(@yaw)) * cos(to_radians(@pitch)));

            @id = spawn_falling_block(@loc, 339, @vector);

            bind('entity_change_block', associative_array('id': 'jokercard'.@id), associative_array('to': 339), 
                    @event, @id, @damage, @player = player()) {
                        
                        @loc = entity_loc(@id);
                        drop_item(@loc,array('type': 339, 'qty': 1))
                        cancel()
                        
            }

            set_interval(50, closure(){
                try {
                    @loc = entity_loc(@id);
                    @loc['y'] -= 1;
                    foreach(@p in entities_in_radius(@loc, 3)) {
                        if(is_entity_living(@p)){
                            damage_entity(puuid(@p), @damage, puuid());
                        }
                    }
                } catch(Exception @ex) {
                    clear_task();
                    unbind('jokercard'.@id);
                }});
                
        }
    )
)
