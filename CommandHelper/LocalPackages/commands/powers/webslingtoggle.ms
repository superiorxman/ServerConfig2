register_command('websling', 

    array(
        'description': 'Turn Lightning Punch on/off',
        'permission': 'ch.alias.websling',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias,@sender,@args) {

            if(array_size(@args) != 1){
                return(false)
            }
            @player = player()
            switch(@args[0]){
                case 'on':
                    export(@player.'webSlingStatus',true)
                    msg(color('RED').'Web Sling on.')
                    break()
                case 'off':
                    export(@player.'webSlingStatus',false)
                    msg(color('RED').'Web Sling off.')
                    break()
                default:
                    msg(color('RED').'The choices are "on" or "off"')
            }
        }
    )
)
