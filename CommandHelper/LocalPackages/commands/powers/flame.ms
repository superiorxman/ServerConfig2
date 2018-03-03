register_command('flame', 
    array(
        'description': 'Set a player on fire',
        'permission': 'ch.alias.flame',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /flame <player>');
                die(); # No need to go further					
            
            }
            
            @plr = player()
            @vic = @args[0]
            @vic = player(@vic)

            if(has_permission(@vic,'is.criminal')){
                tmsg(@plr,color('RED').'Sorry, they are in jail!')
                die()
            }

            assign(@cooldown, 10)
            
            assign(@lastUsedFlame, import(@plr."lastUsedFlame"))
            if(@lastUsedFlame + @cooldown > time() / 1000,
                assign(@timeleft, subtract(add(@lastUsedFlame, @cooldown), divide(time(),1000)))
                tmsg(@plr,concat('§c[§4', Error, '§c] §7You must wait another §6', round(@timeleft), ' §7seconds before you can use flame again!'))
                die()
            )
            export(@plr."lastUsedFlame", time() / 1000)
            
            runas('~console','/burn '.@vic.' 5')
                
        }
    )
)
