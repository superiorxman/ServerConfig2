register_command('costumes', 
    array(
        'description': 'Power',
        'permission': 'command.costume',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @class = _getheroclass(@sender)

            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                @hero = yml_decode(@contents)
            }catch(Exception @e){
                tmsg(@sender,color('RED').'Sorry, this character doesn\'t have any extra skins :(')
                tmsg(@sender,color('RED').'(but you can add some if you want, anyone can! Just take a hero making class, they are held every weekend, but can be held any time upon request.)')
                die()
            }


            @numSkins

            foreach(@costume in @hero['costumes']){
                if(array_index_exists(@costume,'sig')){
                    @numSkins++
                }
            }
            tmsg(@sender,color('RED').'You have '.color('GREEN').@numSkins.color('RED').' costume(s)!')
            @i = 1
            foreach(@cost in @hero['costumes']){
                if(!array_index_exists(@cost,'name')){
                    @cost['name'] = @hero['costumes'][0]['name']
                }
                if(!array_index_exists(@cost,'info')){
                    @cost['info'] = ''
                }else{
                    @cost['info'] = color('WHITE').' ('.color('WHITE').@cost['info'].color('WHITE').')'
                }

                tmsg(@sender,color('RED').'/setcostume '.color('GREEN').@i.color('WHITE').' - '.@cost['name'].@cost['info'])
                @i++
            }
        }
    )
)
