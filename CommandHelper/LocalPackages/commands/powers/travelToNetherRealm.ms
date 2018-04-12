register_command('netherrealm', 
    array(
        'description': 'Power',
        'permission': 'powers.netherrealm',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {
            
            @player = player()
            @target = @args[0]

            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @pClass = _getheroclass(@player)
            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@pClass.'.yml')
                @pHero = yml_decode(@contents)
            }catch(Exception @e){
                @pHero = array('groupWarpRadius': 1000)
            }


            @plrs = players_in_radius(ploc(@player),@pHero['groupWarpRadius'])
            @counter = 0
            @plrList = ''
            foreach(@plr in @plrs){
                if(has_permission(@plr,'is.op')){
                    msg(color('RED').'Sorry, '.@plr.' is in a minigame or other protected area where you can\'t TP to right now.')
                    die()
                }else if(!has_permission(@plr,'is.incity')){
                    if(!has_permission(@plr,'in.survival')){
                        msg(color('RED').'Sorry, '.@plr.' is in a minigame or other protected area where you can\'t TP to right now.')
                        die()
                    }
                }   
                
                @plrList = @plr.', '.@plrList
                sudo('/warp netherrealm '.@plr)
                @counter++
                if(@counter >= @pHero['groupWarpLimit']){
                    break()
                }
            }
            broadcast(@player.' has teleported the group of '.@plrList.' to '.@pHero['groupWarpLocation'])
            sudo('/warp '.@pHero['groupWarpLocation'])
                
        }
    )
)
