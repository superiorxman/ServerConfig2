register_command('wither', 
    array(
        'description': 'Power',
        'permission': 'ch.alias.wither',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /wither <player>');
                die(); # No need to go further					
            
            }
            
            @vic = @args[0]
            @plr = player()
            
            assign(@cooldown, 15)
            
            assign(@lastUsedWither, import(@plr."lastUsedWither"))
            if(@lastUsedWither + @cooldown > time() / 1000,
                assign(@timeleft, subtract(add(@lastUsedWither, @cooldown), divide(time(),1000)))
                tmsg(@plr,concat('§c[§4', Error, '§c] §7You must wait another §6', round(@timeleft), ' §7seconds before you can use mind control again!'))
                die()
            )
            export(@plr."lastUsedWither", time() / 1000)
            
            @targetInRange = false
            @players = players_in_radius(ploc(),2)
            
            foreach(@player in @players){
                if(@player == @vic){
                    @targetInRange = true
                }
            }
            
            if(@targetInRange ==  false){
                tmsg(@plr,color('RED')."You are not close enough to that player")
                die()
            }
            
            sudo("/effect ".@vic." 20 10 2 true")
            tmsg(@plr, "You have withered ".@vic."!")
            tmsg(@vic, "You have been withered by ". @plr ."!")
            
        }
    )
)