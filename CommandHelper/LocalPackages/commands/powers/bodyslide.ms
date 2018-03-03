register_command('bodyslide', 
    array(
        'description': 'Powerslide',
        'permission': 'ch.alias.bodyslide',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure() {
        
            @player = player()
            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @class = _getheroclass(@player)
            
            @allPlayers = all_players()

            if(@class == "deadpool"){
                tmsg(@player,color('RED').'Locating Cable...')
                set_timeout(2000,closure(
                    foreach(@plr in @allPlayers){
                        if(_getheroclass(@plr) == 'cable'){
                            tmsg(@player,color('RED').'Cable Found! Locking on..')
                            set_timeout(1000,closure(
                                tmsg(@player,color('RED').'Lock on successful! Teleporting...')
                                set_timeout(1000,closure(
                                    runas('~console','/minecraft:tp '.@player.' '.@plr)
                                    die()
                                ))
                            ))
                        }
                    }
                    tmsg(@player,color('RED').'Error! Cable not found!')
                ))
            }else{
                tmsg(@player,color('RED').'Locating Deadpool...')
                set_timeout(2000,closure(
                    foreach(@plr in @allPlayers){
                        if(_getheroclass(@plr) == 'deadpool'){
                            tmsg(@player,color('RED').'Deadpool Found! Locking on..')
                            set_timeout(1000,closure(
                                tmsg(@player,color('RED').'Lock on successful! Teleporting...')
                                set_timeout(1000,closure(
                                    runas('~console','/minecraft:tp '.@player.' '.@plr)
                                    die()
                                ))
                            ))
                        }
                    }
                    tmsg(@player,color('RED').'Error! Deadpool not found!')
                ))
            }
            
        }
    )
)
