register_command('cat', 
    array(
        'description': 'Power',
        'permission': 'powers.cat',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) { 

            if(array_size(@args) != 0){
                msg(color('RED').'Usage: /cat')
                return(false)
            }

            sudo('/summon cat')
            
        }
    )
)
