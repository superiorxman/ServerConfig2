register_command('effects', 
    array(
        'description': 'Gives Player their Superhero Powers',
        'usage': '/buff',
        'permission': 'command.effects',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure() {
        
            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @plr = player()
            @class = _getheroclass(@plr)
          
            try {
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                @hero = yml_decode(@contents)
                
            } catch (IOException @ErrorInfo) {
                tmsg(@plr, 'There\'s no effects\'s associated with your current character :(')
                die()
            }
            queue_push(closure(runas('~console','/effect '.@plr.' clear')))
            if(array_index_exists(@hero,'effects')){
                foreach(@effect in @hero['effects']){
                    @effect = replace(@effect,'<plr>',@plr)
                    queue_push(closure(runas('~console',@effect)))
                }
            }

            if(has_permission(@plr,'essentials.fly')){
                run_cmd('/fly on')
            }
        }
    )
)