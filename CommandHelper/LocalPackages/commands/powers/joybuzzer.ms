register_command('joybuzzer', 
    array(
        'description': 'Powerslide',
        'permission': 'powers.joybuzzer',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alises, @sender, @args) {
        
            if(array_size(@args) != 1){
                tmsg(@sender,color('RED').'Usage: /joybuzzer <player>')
                die()
            }

            @vic = @args[0]
            @vic = player(@vic)

            @ploc = ploc(@sender)
            @vloc = ploc(@vic)

            if(distance(@ploc,@vloc) > 1){
                tmsg(@sender,color('RED').'Sorry, you are too far away from that player, please get within touching distance.')
                die()
            }

            damage_entity(puuid(@vic),1,puuid(@sender))
            tmsg(@sender,color('RED').'You joy buzzer\'d '.@vic)
            tmsg(@vic,color('RED').'You got joy buzzer\'d!')
        }
    )
)
