register_command('items', 
    array(
        'description': 'Gives Player their Superhero Powers',
        'usage': '/buff',
        'permission': 'command.items',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure() {
        
            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @plr = player()
            @class = _getheroclass(@plr)
          
            try {
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                @hero = yml_decode(@contents)
                
            } catch (IOException @ErrorInfo) {
                tmsg(@plr, 'There\'s no items\'s associated with your current character :(')
                die()
            }
            queue_push(closure(runas('~console','/minecraft:clear '.@plr)))
            if(array_index_exists(@hero,'items')){
                foreach(@item in @hero['items']){
                    @item = replace(@item,'<plr>',@plr)
                    queue_push(closure(runas('~console',@item)))
                }
            }
        }
    )
)