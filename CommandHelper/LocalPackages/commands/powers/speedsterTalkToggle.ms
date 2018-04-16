register_command('speedstertalk', 

    array(
        'description': 'Turn Wallrun on/off',
        'permission': 'powers.speedstertalk',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias,@sender,@args) {

            if(array_size(@args) != 1){
                return(false)
            }
            @player = player()
            switch(@args[0]){
                case 'on':
                    export(@player.'speedsterTalkStatus',true)
                    msg(color('RED').'Speedster talk on.')
                    break()
                case 'off':
                    export(@player.'speedsterTalkStatus',false)
                    msg(color('RED').'Speedster talk off.')
                    break()
                default:
                    msg(color('RED').'The choices are "on" or "off"')
            }
        }
    )
)
