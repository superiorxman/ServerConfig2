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


            @numExtraSkins = -1

            foreach(@costume in @hero['costumes']){
                if(array_index_exists(@costume,'sig')){
                    @numExtraSkins++
                }
            }

            if(@numExtraSkins > 0){
                tmsg(@sender,color('RED').'You have '.color('GREEN').@numExtraSkins.color('RED').' extra costume(s)!')
                for(@i = 2, @i <= @numExtraSkins + 1, @i++){
                    tmsg(@sender,color('RED').'/setcostume '.@i)
                }
            }else{
                tmsg(@sender,color('RED').'Sorry, this character doesn\'t have any extra skins :(')
                tmsg(@sender,color('RED').'(but you can add some if you want, anyone can! Just take a hero making class, they are held every weekend, but can be held any time upon request.)')
            }
        }
    )
)
