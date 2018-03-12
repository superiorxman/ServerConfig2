register_command('setname', 
    array(
        'description': 'Power',
        'permission': 'command.setname',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {

            if(array_size(@args) > 1){
                tmsg(@sender,color('RED').'Usage: /setname <number>')
                return()
            }

            if(array_size(@args) < 1){
                include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                @class = _getheroclass(@sender)
                try{
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                    @hero = yml_decode(@contents)
                }catch(Exception @e){
                    tmsg(@sender,color('RED').'Sorry, you are not a character with multiple skins.')
                    return()
                }
                @numNames = array_size(@hero['costumes'])
                if(array_index_exists(@hero['costumes'],@reqestedNum) && @numNames > 1 ){
                    tmsg(@sender,color('RED').'You have '.@numNames.' names. Try switching by doing '.color('GREEN').'/setname <number>')
                }else{
                    tmsg(@sender,color('RED').'Sorry, you are not a character with multiple skins.')
                }
                return()
            }
            if(!is_numeric(@args[0])){
                tmsg(@sender,color('RED').'Usage: /setname <number>')
            }
            
            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @class = _getheroclass(@sender)

            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                @hero = yml_decode(@contents)
            }catch(Exception @e){
                tmsg(@sender,color('RED').'Sorry, you are not a character with multiple skins.')
                return()
            }
            @reqestedNum = @args[0] - 1
            if(array_index_exists(@hero['costumes'],@reqestedNum)){
                @niceName = replace(@hero['costumes'][@reqestedNum]['name'],'§','&')
                runas('~console','/pex group #'.@class.' prefix "'.@niceName.'"')
                runas('~console','/pex group #'.@class.' suffix "'.@hero['costumes'][@reqestedNum]['chatcolor'].'"')
                tmsg(@sender,color('RED').'Name set!')
            }else{
                tmsg(@sender,color('RED').'Sorry, you are not a character with multiple skins.')
            }

        }
    )
)
