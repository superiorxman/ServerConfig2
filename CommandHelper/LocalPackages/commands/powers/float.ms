register_command('float', 

    array(
        'description': 'Float',
        'permission': 'powers.float',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
            if (array_size(@args) != 1) {
                return(false)
            }
            @player = player()
            @choice = @args[0]
            switch(@choice){
                case 'up':
                    runas('~console','/effect '.@player.' minecraft:levitation 0')
                    runas('~console','/effect '.@player.' minecraft:levitation 9999 1 true')
                    break()
                case 'down':
                    runas('~console','/effect '.@player.' minecraft:levitation 0')
                    runas('~console','/effect '.@player.' minecraft:levitation 9999 254 true')
                    break()
                case 'hover':
                    runas('~console','/effect '.@player.' minecraft:levitation 0')
                    runas('~console','/effect '.@player.' minecraft:levitation 9999 255 true')
                    break()
                case 'stop':
                    runas('~console','/effect '.@player.' minecraft:levitation 0')
                    break()
                default:
                    msg(color('RED').'The choices are: up down pause unpause stop')
            }
        }
    )
)
