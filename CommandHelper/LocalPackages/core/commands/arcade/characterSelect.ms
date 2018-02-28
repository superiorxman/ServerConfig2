register_command(chars, 
    array(
        description: 'Lists the Super Heroes available on the Server',
        usage: '/chars [page number]',
        permission: 'ch.alias.listheroes',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',
        executor: closure(@alias, @sender, @args) {
        
            if (array_size(@args) > 1) {
                return(FALSE)
            } else if (array_size(@args) == 1) {
                @pageNum = @args[0]
            } else {
                @pageNum = null
            }
    
            if(@pageNum < 1 && @pageNum != null){
                msg(color(RED).color(BOLD).'Sorry, the page number must be at least 1.');
                die()
            }

            //@files = list_files('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/')
            @fString = shell('/home/minecraft/getHeroesAlphabetically.sh')
            @fString = trimr(@fString)
            @files = split('\n',@fString)
            if(@pageNum == null){
                for(@i = 0, @i < 10, @i++){
                    try{
                        @class = substr(@files[@i],0,string_position(@files[@i],'.'))
                        @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                        @hero = yml_decode(@contents)
                        runas(~console,'/tellraw '.@sender.' {"text":"'.@hero['name'].'","color":"gold","clickEvent":{"action":"run_command","value":"/selectchar '.@hero['class'].'"},"hoverEvent":{"action":"show_text","value":"'.@hero['class'].'"}}')
                    }catch(Exception @e){
                        break()
                    }
                }
                msg(color(RED).'For more characters check out '.color(GREEN).color(BOLD).'/chars 2')
            }else{
                @start = @pageNum * 10 - 9
                for(@i = @start, @i < @start+10, @i++){
                    try{
                        @class = substr(@files[@i],0,string_position(@files[@i],'.'))
                        @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                        @hero = yml_decode(@contents)
                        runas(~console,'/tellraw '.@sender.' {"text":"'.@hero['name'].'","color":"gold","clickEvent":{"action":"run_command","value":"/selectchar '.@hero['class'].'"},"hoverEvent":{"action":"show_text","value":"'.@hero['class'].'"}}')
                    }catch(Exception @e){
                        break()
                    }
                }
                msg(color(RED).'For more characters check out '.color(GREEN).color(BOLD).'/chars '.(@pageNum + 1))
            }
        }
    )
)


register_command(characterselect, 
    array(
        description: 'Searches for a character',
        usage: '/characterselect <searchterm>',
        permission: 'command.characterselect',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',		
        aliases: array('charsel', 'findchar','csel'),
        executor: closure(@alias, @sender, @args) {
            @argNum = array_size(@args)
            if (@argNum < 1) {
                msg(color(YELLOW).'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                msg(color(RED).'Please search for a character.')
                msg('Example:'.color(GREEN).' /findchar wonder woman')
                msg('Example:'.color(GREEN).' /findchar Captain America')
                msg('Example:'.color(GREEN).' /findchar greenlantern')
                msg(color(YELLOW).'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                return(FALSE)
            }
 
            @searchTerm = ''
            foreach(@arg in @args){
                @searchTerm = @searchTerm.@arg
            }
            @heroes = array()

            @var = shell('/home/minecraft/searchHero.sh '.@searchTerm)
            @heroes = split('\n',@var)
            msg(color(YELLOW).'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
            @foundAHero = false
            foreach(@her in @heroes){

                try{
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.replace(@her,'\n','').'.yml')
                    @hero = yml_decode(@contents)
                    @foundAHero = true
                    queue_push(closure(runas(~console,'/tellraw '.@sender.' {"text":"'.@hero['name'].'","color":"gold","clickEvent":{"action":"run_command","value":"/selectchar '.@her.'"},"hoverEvent":{"action":"show_text","value":"'.@her.'"}}')))
                    
                }catch(IOException @e){
                    continue()
                }
            }
            queue_push(closure(
            if(@foundAHero){
                msg(color(RED).'Click a character to select it.')
            }else{
                msg(color(RED).'Sorry, we don\'t have that character yet :(')
                msg(color(RED).'You can add it to the server by watching the following videos:')
                msg(color(RED).'Please note, only the 1st 3 videos are required, the rest are optional.')
                msg(color(GREEN).'http://mynecraft.servegame.com/howtomakeahero.html')
            }
            msg(color(YELLOW).'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
            ))
       }
    )
)


register_command(selectchar, 
    array(
        description: 'Selects a character',
        usage: '/selectchar <character>',
        permission: 'command.selectchar',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',		
        executor: closure(@alias, @sender, @args) {
                @argNum = array_size(@args)
                if (@argNum != 1) {
                    msg(color(RED).'Error: Incorrect parameters. Try: /selectchar superman')
                    return(FALSE)
                }

                @player = @sender
                @class = @args[0]
                
                @confirmed = import(@player."charConfirmed")
                if(@confirmed != @class){
                    export(@player."charConfirmed",@class)
                    msg(@class.color(RED).' selected! Please click again to confirm your choice.')
                    die()
                }
                @forgottenHeroes = import('forgottenHeroes')
                if(@forgottenHeroes != null){
                    if(is_array(@forgottenHeroes)){
                        foreach(@fhero in @forgottenHeroes){
                            if(@fhero == @class){
                                msg(color(RED).'Sorry, that hero is currently locked. Please check back later.')
                                die()
                            }
                        }
                    }else{
                        if(@forgottenHeroes == @class){
                            msg(color(RED).'Sorry, that hero is currently locked. Please check back later.')
                            die()
                        }
                    }
                }
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/' . @class . '.yml')
                @hero = yml_decode(@contents)
                @plrs = all_players()
                include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                foreach(@playa in @plrs)
                {
                    @otherPlayerGroup = _getheroclass(@playa)
                    if(@otherPlayerGroup == @hero['class'] && @player != @playa){
                        msg(color(YELLOW).'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                        msg(color(RED).'Sorry, '.color(WHITE).@playa.color(RED).' is already using '.@hero['name'].color(RED).'.')
                        msg(color(DARK_RED).'Please choose a different character.')
                        msg(color(YELLOW).'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                        die()
                    }
                    if(array_index_exists(@hero,'alts')){
                        @alts = @hero['alts']
                        foreach(@alt in @alts){
                            if(@alt == @otherPlayerGroup){
                                @h1 = @hero['name']
                                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/' . @class . '.yml')
                                @hero = yml_decode(@contents)
                                @h2 = @hero['name']
                                msg(color(YELLOW).'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                                msg(color(RED).'Sorry, '.color(WHITE).@playa.color(RED).' is already using '.@h2.color(RED).'.')
                                msg(color(RED).'Try again with:')
                                msg(color(GREEN).'/characterselect')
                                msg(color(YELLOW).'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
                                die()
                            }
                        } 
                    }
                }
                clear_task(import(@player.'isBurningInSunlight'))
                export(@player.'skinNum',1)
                if(@class == 'fanfic'){
                    @uuid = puuid(@player,true)
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' delete')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' create')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' parents set #commonherotraits')))
                    queue_push(closure(runas(~console,'/pex user '.@player.' group set #'.@class.@uuid)))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.run0 superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.run1 superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.run2 superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.haste0 superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.haste1 superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.haste2 superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.jump0 superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.jump1 superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.jump2 superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.fanficlaser superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.fanficname superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add ch.alias.fanficchatcolor superherocity')))
                    queue_push(closure(runas(~console,'/pex group #'.@class.@uuid.' add is.fanfic superherocity')))
                    broadcast(color(GRAY).color(ITALIC).'A shitty fanfic has entered the game!')
                    queue_push(closure(runas(~console,"/fly ".@player." off")))
                    queue_push(closure(runas(~console,"/gamemode survival ".@player)))
                    queue_push(closure(runas(~console,"/effect ".@player." clear")))
                    queue_push(closure(runas(~console,"/minecraft:clear" @player)))
                    queue_push(closure(runas(~console,"/god ".@player." off")))
                    queue_push(closure(runas(~console,"/tptoggle ".@player." on")))
                    queue_push(closure(sudo('/stageselect')))
                    die()
                }

                #if(array_index_exists(@hero,'eraserebuild')){
                    queue_push(closure(runas(~console,'/minecraft:clear '.@player)))
                    set_peffect(@player, 14, 1, 9999, true, false)
                    queue_push(closure(runas(~console,'/pex group #'.@hero['class'].' delete')))
                    queue_push(closure(runas(~console,'/pex group #'.@hero['class'].' create')))
                    queue_push(closure(runas(~console,'/pex user #'.@player.' group set #'.@hero['class'])))
                    queue_push(closure(runas(~console,'/pex group #'.@hero['class'].' parents set #commonherotraits')))
                    queue_push(closure(runas(~console,'/pex group #'.@hero['class'].' suffix '.@hero['chatcolor'])))
                    @niceName = replace(@hero['name'],'§','&')
                    queue_push(closure(runas(~console,'/pex group #'.@hero['class'].' prefix "'.@niceName.'"')))
                    if(array_index_exists(@hero,'permissions') && is_array(@hero['permissions'])){
                        foreach(@worldName: @worldPerms in @hero['permissions']){
                            foreach(@perm in @worldPerms){
                                queue_push(closure(runas(~console,'/pex group #'.@hero['class'].' add '.@perm.' '.@worldName)))
                            }
                        }
                    }
                #}
                queue_push(closure(runas(~console,"/fly ".@player." off")))
                queue_push(closure(runas(~console,"/gamemode survival ".@player)))
                queue_push(closure(runas(~console,"/effect ".@player." clear")))
                queue_push(closure(runas(~console,"/god ".@player." off")))
                queue_push(closure(runas(~console,"/tptoggle ".@player." on")))
                
#                include('/home/minecraft/server/plugins/CommandHelper/includes/changeSkin.ms')
#                _changeSkin(@player,@hero['sig'],@hero['val'],@hero['name'])
                if(@hero['trail'] != ''){
                    sudo("/trailsid ".@hero['trail'])
                }else{
                    sudo("/trailsid none")
                }
                queue_push(closure(sudo('/stageselect')))
        }
    )
)
