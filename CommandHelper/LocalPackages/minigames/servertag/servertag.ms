register_command('whosit', 
    array(   
        'description': '',
        'usage': '/whosit',
        'permission': 'whos.it',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {

            @it = import('it')
            if(@it != null){
                tmsg(@sender,@it.' is it!')
                tmsg(@sender,'They are at ')
                @ploc = ploc(@it)
                tmsg(@sender,color('RED').'X: '.color('GOLD').integer(@ploc['x']))
                tmsg(@sender,color('RED').'Y: '.color('GOLD').integer(@ploc['y']))
                tmsg(@sender,color('RED').'Z: '.color('GOLD').integer(@ploc['z']))
                tmsg(@sender,color('RED').'world: '.color('GOLD').@ploc['world'])
            }else{
                tmsg(@sender,'No one is it at the moment.')
            }

        }
    )
)

bind('entity_damage_player',null,array('type':'PLAYER'),@e){
    @playerGettingDamaged = @e['player']
    @it = import('it')
    if(@it != null  && @playerGettingDamaged == @it){
        @playerDoingDamage = player(@e['id'])
        @it = @playerDoingDamage
        //@it[1] = time()
        export('it',@it)

        broadcast(color('GRAY').color('ITALIC').@playerDoingDamage.' tagged '.@playerGettingDamaged.'! '.@playerDoingDamage.' is IT!')
        broadcast(color('GRAY').color('ITALIC').'Do '.color('GREEN').'/whosit'.color('GRAY').color('ITALIC').' to find them!')
    }
}