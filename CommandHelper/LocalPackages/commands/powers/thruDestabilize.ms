register_command('thrudestabilize', 
    array(
        'description': 'Power',
        'permission': 'ch.alias.thrudestabilize',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure() {        
            
            sudo("/thru")
            set_timeout(500,closure(
                @ploc = ploc()
                explosion(@ploc,null,true)
            ))                
        }
    )
)