register_command('flywithrider', 

    array(
        'description': 'Checks the Arrest and Warning History of an Officer',
        'usage': '/flywithrider',
        'permission': 'powers.flywithrider',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
            if (array_size(@args) != 0) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /flywithrider');
                return()
            }

            @senderUUID = puuid(@sender)
            @entityRider = get_entity_rider(@senderUUID)

            if(@entityRider != null){
                sudo('/fly on')
                bind('entity_dismount',null,null,@e,@entityRider,@sender){
                    if(@e['id'] == @entityRider){
                        set_pflight(@sender,false)
                        tmsg(@sender,color('RED').'Your passenger left! You can\'t fly without a passenger!')
                    }
                }
            }else{
                tmsg(@sender,color('RED').'Sorry, you need a passenger to fly.')
            }
        }
    )
)
