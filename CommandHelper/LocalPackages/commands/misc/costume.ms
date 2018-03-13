register_command('setcostume', 

    array(
    
        'description': 'Change your Hero Skin to an Alternate Skin',
        'usage': '/setcostume <number>',
        'permission': 'command.costume',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
                if (array_size(@args) != 1) {
                
                    msg(color\('RED').color\('BOLD').'Improper Usage!');
                    msg(color\('RED').'Usage: /setcostume <number>');
                    die(); # No need to go further					
                
                }
                
                @player = @sender
                @skinNum = @args[0]

                if(@skinNum <= 0){
                    tmsg(@player,"Skin number has to be at least 1")
                    die()
                }

                include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                @class = _getheroclass(@player)
                
                try{
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                    @hero = yml_decode(@contents)
                }catch(Exception @e){
                    tmsg(@player,"Sorry, this hero doesn't have a skin number ". @skinNum)
                    export(@player.'skinNum',1)    
                    queue_push(closure(runas('~console','/undisguiseplayer '.@plr)))
                    return()
                }

                

                export(@player.'skinNum',@skinNum)
                if(@skinNum == 1){
                    if(!array_index_exists(@hero['costumes'][0],'info')){
                        @hero['costumes'][0]['info'] = color('WHITE').' #1'
                    }else{
                        @hero['costumes'][0]['info'] = color('WHITE').' #1. ('.@hero['costumes'][0]['info'].color('WHITE').')'
                    }
                    @sig = @hero['costumes'][0]['sig']
                    @val = @hero['costumes'][0]['val']
                    @niceName = replace(@hero['costumes'][0]['name'],'§','&')
                    runas('~console','/pex group #'.@class.' prefix "'.@niceName.'"')
                    runas('~console','/pex group #'.@class.' suffix "'.@hero['costumes'][0]['chatcolor'].'"')

                    

                    tmsg(@sender,color('RED').'Costume is now set to '.@hero['costumes'][0]['info'])
                    broadcast(@sender.' '.color('GRAY').'switched costumes into '.@hero['costumes'][0]['name'].@hero['costumes'][0]['info'])
                }else{
                    @skinNum = @skinNum - 1
                    if(!array_index_exists(@hero['costumes'][@skinNum],'name')){
                        @hero['costumes'][@skinNum]['name'] = @hero['costumes'][0]['name']
                    }

                    if(!array_index_exists(@hero['costumes'][@skinNum],'info')){
                        @hero['costumes'][@skinNum]['info'] = color('WHITE').' #'.(@skinNum + 1)
                    }else{
                        @hero['costumes'][@skinNum]['info'] = color('WHITE').' #'.(@skinNum + 1).'. ('.@hero['costumes'][@skinNum]['info'].color('WHITE').')'
                    }
                    @sig = @hero['costumes'][@skinNum]['sig']
                    @val = @hero['costumes'][@skinNum]['val']
                    if(array_index_exists(@hero['costumes'][@skinNum],'chatcolor')){
                        @niceName = replace(@hero['costumes'][@skinNum]['name'],'§','&')
                        runas('~console','/pex group #'.@class.' prefix "'.@niceName.'"')
                        runas('~console','/pex group #'.@class.' suffix "'.@hero['costumes'][@skinNum]['chatcolor'].'"')
                        tmsg(@sender,color('RED').'Costume is now set to '.@hero['costumes'][@skinNum]['info'])
                        broadcast(@sender.' '.color('GRAY').'switched costumes into '.@hero['costumes'][@skinNum]['name'].@hero['costumes'][@skinNum]['info'])
                    }else{
                        tmsg(@sender,color('GREEN').'Skin Changed Successfully!')
                        tmsg(@sender,color('DARK_RED').color('BOLD').'Warning: '.color('RED').'Each skin should have a matching colored name, but this one is missing!')
                        tmsg(@sender,color('GOLD').'Ask someone to make it for you!')
                        broadcast(@sender.' '.color('GRAY').'switched costumes into '.@hero['costumes'][@skinNum]['name'].@hero['costumes'][@skinNum]['info'])
                    }
                }
                include('/home/minecraft/server/plugins/CommandHelper/includes/changeSkin.ms')
                _changeSkin(@player,@sig,@val,@hero['costumes'][0]['name'])
        }
    )
)
