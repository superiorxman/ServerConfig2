register_command('skin', 

    array(
    
        'description': 'Change your Hero Skin to an Alternate Skin',
        'usage': '/skin <number>',
        'permission': 'ch.alias.skin',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
                if (array_size(@args) != 1) {
                
                    msg(color\('RED').color\('BOLD').'Improper Usage!');
                    msg(color\('RED').'Usage: /skin <number>');
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
                    @sig = @hero['sig']
                    @val = @hero['val']
                }else{
                    @skinNum = @skinNum - 2
                    @sig = @hero['altskins'][@skinNum]['sig']
                    @val = @hero['altskins'][@skinNum]['val']
                }
                include('/home/minecraft/server/plugins/CommandHelper/includes/changeSkin.ms')
                _changeSkin(@player,@sig,@val,@hero['name'])
        }
    )
)
