register_command('buff', 
    array(
        'description': 'Gives Player their Superhero Powers',
        'usage': '/buff',
        'permission': 'ch.alias.buff',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure() {
        
            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @plr = player()
            @class = _getheroclass(@plr)
          
            try {
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                @hero = yml_decode(@contents)
                
            } catch (IOException @ErrorInfo) {
                tmsg(@plr, 'There\'s no buffs\'s associated with your current Character Class')
                die()
            }
            if(array_index_exists(@hero,'buffs')){
                foreach(@power in @hero['buffs']){
                    @power = replace(@power,'<plr>',@plr)
                    queue_push(closure(runas('~console',@power)))
                }
            }

            if(has_permission(@plr,'essentials.fly')){
                run_cmd('/fly on')
            }

            @puuid = puuid(@plr)
            if(array_index_exists(@hero,'maxHearts')){
                queue_push(closure(set_attribute(@puuid,'maxHealth',(@hero['maxHearts'] * 2))))
                queue_push(closure(set_phealth(@plr,(@hero['maxHearts'] * 2))))
            }else{
                queue_push(closure(set_attribute(@puuid,'maxHealth',20)))
            }
            if(array_index_exists(@hero,'speech')){
                queue_push(closure(tmsg(@plr,@hero['speech'])))
            }
        }
    )
)