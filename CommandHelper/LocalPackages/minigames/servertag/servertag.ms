register_command('whosit', 
    array(   
        'description': '',
        'usage': '/whosit',
        'permission': 'whos.it',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {

            @it = import('it')
            if(@it != null){
                tmsg(@sender,@it[0].' is it!')
            }else{
                tmsg(@sender,'No one is it at the moment.')
            }

        }
    )
)

bind('entity_damage_player',null,array('type':'PLAYER'),@e){
    @playerDoingDamage = get_player_from_entity_id(@e['id'])
    @it = import('it')
    if(@it != null && @playerDoingDamage == @it[0]){
        @playerGettingDamaged = @e['player']
        @it[0] = @playerGettingDamaged
        @it[1] = time()
        export('it',@it)

        broadcast(color('GRAY').color('ITALIC').@playerDoingDamage.' tagged '.@playerGettingDamaged.'! '.@playerGettingDamaged.' is IT!')
    }
}