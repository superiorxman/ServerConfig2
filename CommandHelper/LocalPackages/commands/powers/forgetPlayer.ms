register_command('forget', 
    array(
        'description': 'Erase a hero from history',
        'permission': 'powers.forget',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 0) {
                return(false) 
            }
            
            @ploc = ploc(@sender)
            @aPlrs = players_in_radius(@ploc,5)
            if(array_size(@aPlrs) >= 2){
                if(@aPlrs[0] == @sender){
                    @vic = @aPlrs[1]
                }else{
                    @vic = @aPlrs[0]
                }
            }else{
                tmsg(@sender,color('RED').'Sorry, there is no one close enough!')
                die()
            }

            if(@sender == @vic){
                tmsg(@sender,color('RED').'Sorry, this does not work on yourself!')
                die()
            }
            if(has_permission(@vic,'is.criminal')){
                tmsg(@sender,color('RED').'Sorry, they are in jail!')
                die()
            }
            
            if(has_permission(@vic,'is.immune')){
                tmsg(@sender,color('RED').'Sorry, you cannot do that to them!')
                die()
            }


            include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
            if(_coolDown(@sender.'forgetPlayer',600,@sender)){
                return()
            }

            
            include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
            @class = _getheroclass(@vic)

            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                @hero = yml_decode(@contents)
                @vicHero = @hero
            }catch(Exception @e){
                @vicHero = array('name': @vic)
            }

            @class = _getheroclass(@sender)
            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                @hero = yml_decode(@contents)
                @plrHero = @hero
            }catch(Exception @e){
                @plrHero = array('name': @sender)
            }

            if(array_index_exists(@vicHero,'costumes')){
                @alts = @vicHero['costumes']
                array_push(@alts,@vicHero['class'])
                export('forgottenHeroes',@alts)
            }else{
                export('forgottenHeroes',@vicHero['class'])
            }

            runas(@vic,'/mainmenu')

            set_timeout(300000,closure(
                @existingForgottenHeroes = import('forgottenHeroes')
                if(is_array(@existingForgottenHeroes)){
                    array_remove_values(@existingForgottenHeroes,@pClass)
                }else{
                    @existingForgottenHeroes = null
                }
                export('forgottenHeroes',@existingForgottenHeroes)
            ))

            broadcast(@plrHero['chat'][0]['name'].color('RED').' throws '.@vicHero['chat'][0]['name'].color('RED').' into The Overvoid! Their memory fades from existence...')
                
        }
    )
)
