register_command('autobuff', 

    array(
        'description': 'Turn autobuff on/off',
        'permission': 'powers.autobuff',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias,@sender,@args) {

            if(array_size(@args) != 1){
                return(false)
            }
            @player = player()
            switch(@args[0]){
                case 'on':
                    export(@player.'autoBuffStatus',true)
                    msg(color('RED').'Auto Buff on.')
                    break()
                case 'off':
                    export(@player.'autoBuffStatus',false)
                    msg(color('RED').'Auto Buff off.')
                    break()
                default:
                    msg(color('RED').'The choices are "on" or "off"')
            }
        }
    )
)
