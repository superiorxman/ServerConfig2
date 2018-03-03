register_command('arrest', 

    array(
        'description': 'Arrests a player and Jails them',
        'usage': '/arrest <player> <reason>',
        'permission': 'ch.alias.arrest',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
                if (array_size(@args) < 2) {
                
                    msg(color('RED').color('BOLD').'Improper Usage!');
                    msg(color('RED').'Usage: /arrest <player> <reason>');
                    die(); # No need to go further					
                
                }
                
                try {
                    @plr = player(@args[0])					
                    @cop = player()
                    @vicUUID = puuid(@plr)
                    @ip = pinfo(@plr)[3]
                    
                    @reason = ''
                    @argsLength = array_size(@args)
                    
                    if(@cop[0] != '#') {
                    
                        if(@cop != '~console' && has_permission(@cop, 'is.suspended')) {
                        
                            msg(color('RED').color('BOLD').'You are currently suspended! Your powers of arrest have been revoked.');
                            die();
                        
                        }
                    
                    }
                    
                    if(has_permission(@plr, 'ch.alias.onduty') && !pisop(@plr)){
                    
                        runas("~console", "/pex user ".@plr." add is.suspended");
                    
                    }
                    
                    for (@i = 1, @i < @argsLength, @i++){
                    
                        @reason = @reason.@args[@i].' '
                    
                    }
                    
                    @reason = trim(@reason)
                    
                    @date = simple_date('hh:mm aaa z',time(),'CST')

                    runas('~console', '/sudo '.@plr.' c:/ch leave local')
                    runas('~console', '/sudo '.@plr.' c:/ch join global')
                    include('/home/minecraft/server/plugins/CommandHelper/includes/mortal.ms')
                    _mortal(@plr)
                    
                    if (@cop[0] == '#') {
                        broadcast(@plr.color('RED').' HAS BEEN ARRESTED BY '.color('WHITE').'The Server'.color('RED').' FOR '.color('YELLOW').@reason)
                    } else {
                        broadcast(@plr.color('RED').' HAS BEEN ARRESTED BY '.color('WHITE').@cop.color('RED').' FOR '.color('YELLOW').@reason)					
                    }

                    @profile = array('type': 'sqlite', 'file': '/home/minecraft/server/plugins/CommandHelper/policedatabase.sqlite')
                    
                    @date = simple_date('yyyy-MM-dd HH:mm:ss', time())
                    if (@cop[0] == '#') {
                        @result = query(@profile,'INSERT INTO `criminals` '.
                                                 'VALUES(?,?,?,?,?,?,?,?)',
                                                 @plr,@vicUUID,@reason,'ARREST',@ip,@cop,'server-command-block',simple_date('yyyy-MM-dd HH:mm:ss', time())
                        )
                    } else {
                        @result = query(@profile,'INSERT INTO `criminals` '.
                                                 'VALUES(?,?,?,?,?,?,?,?)',
                                                 @plr,@vicUUID,@reason,'ARREST',@ip,@cop,puuid(@cop),simple_date('yyyy-MM-dd HH:mm:ss', time())
                        )
                    }
                    set_timeout(3000,closure(
                        runas("~console", "/pex user ".@plr." group set criminal")
                        runas("~console", "/tptoggle ".@plr." off")
                        runas("~console", "/warp quarantine ".@plr)						
                    ))			
                    set_timeout(5000,closure(
                        set_pmode(@plr,'SURVIVAL')					
                    ))			
                } catch (PlayerOfflineException @ErrorInfo) {				
                    msg('Player is Offline')
                    die()
                }				
                
                
        
        }
    )
)

register_command('release', 
    array(
        'description': 'Release a player from Jail',
        'usage': '/release <player>',
        'permission': 'ch.alias.release',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
                if (array_size(@args) != 1) {
                
                    msg(color('RED').color('BOLD').'Improper Usage!');
                    msg(color('RED').'Usage: /release <player>');
                    die(); # No need to go further					
                
                }
                
                if(has_permission(player(), 'is.suspended')) {
                    
                        msg(color('RED').color('BOLD').'You are currently suspended! Your powers to release have been revoked.');
                        die();
                    
                    }
                
                try {
                    @plr = player(@args[0])
                    runas("~console", "/pex user ".@plr." group set mortal")
                    runas("~console", "/warp city ".@plr)
                    runas("~console", "/tptoggle ".@plr." on")	
                } catch (PlayerOfflineException @ErrorInfo) {				
                    msg('Player is Offline')
                    die()
                }
                
        }
    )
)

register_command('warn', 

    array(
        'description': 'Warns a player for Behavior and records Infraction',
        'usage': '/warn <player> <reason>',
        'permission': 'ch.alias.warn',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
                if (array_size(@args) < 2) {
                
                    msg(color('RED').color('BOLD').'Improper Usage!');
                    msg(color('RED').'Usage: /warn <player> <reason>');
                    die(); # No need to go further					
                
                }
                
                try {
                    @plr = player(@args[0])
                    @cop = player()
                    @uuid = puuid(@plr)
                    @ip = pinfo(@plr)[3]
                    
                    @reason = ''
                    @argsLength = array_size(@args)
                    
                    if(has_permission(@cop, 'is.suspended')) {
                    
                        msg(color('RED').color('BOLD').'You are currently suspended! Your powers to warn have been revoked.');
                        die();
                    
                    }
                    
                    for (@i = 1, @i < @argsLength, @i++){
                    
                        @reason = @reason.@args[@i].' '
                    
                    }
                    
                    @reason = trim(@reason)
                    
                    broadcast(color('BOLD').@plr.color('DARK_RED').color('BOLD').' HAS BEEN WARNED BY '.color('WHITE').@cop.color('DARK_RED').color('BOLD').' ON THE GROUNDS OF '.color('YELLOW').@reason.color('RED').color('BOLD').'. Please read '.color('DARK_RED').'/rules'.color('RED').' and familiarize yourself with the server rules or you may end up jailed!')

                    @profile = array('type': 'sqlite', 'file': '/home/minecraft/server/plugins/CommandHelper/policedatabase.sqlite')
                    query(@profile,'INSERT INTO `criminals` '.
                                   'VALUES(?,?,?,?,?,?,?,?)',
                                   @plr,@uuid,@reason,'WARN',@ip,@cop,puuid(@cop),simple_date('yyyy-MM-dd HH:mm:ss', time())
                    )			
                } catch (PlayerOfflineException @ErrorInfo) {				
                    msg('Player is Offline')
                    die()
                }				
                
                runas('~console','/sudo '.@plr.' c:/warp police')
                runas('~console','/warp warncop '.@cop)
                runas('~console','/warp warnperp '.@plr)

        
        }
    )
)

register_command('checkfingerprints', 

    array(
        'description': 'Checks for Information on a Player',
        'usage': '/checkfingerprints <player>',
        'permission': 'ch.alias.checkfingerprints',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /checkfingerprints <player>');
                die(); # No need to go further					
            
            }

            try {
                @plr = player(@args[0])
                @cop = player()
                
                if(has_permission(@cop, 'is.suspended')) {
                    
                        msg(color('RED').color('BOLD').'You are currently suspended! You may not access the Police Database');
                        die();
                    
                }
                
                
                @ip = pinfo(@plr)[3]
                @profile = array('type': 'sqlite', 'file': '/home/minecraft/server/plugins/CommandHelper/policedatabase.sqlite')
                @result = query(@profile, 'SELECT DISTINCT PERPNAME,IP FROM `criminals` WHERE IP=?',@ip)
                foreach(@row in @result){
                    tmsg(@cop,@row['PERPNAME'])
                }
            } catch (PlayerOfflineException @ErrorInfo) {				
                msg('Player is Offline')
                die()
            }                          
        
        }
    )
)

register_command('removerecord', 

    array(
        'description': 'Removes a players record',
        'usage': '/removerecord <player> <date> <time>',
        'permission': 'ch.alias.removerecord',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 3) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /removerecord <player> <date> <time>');
                die(); # No need to go further					
            
            }
            
            @plr = @args[0]
            @date = @args[1].' '.@args[2]
            @cop = player()                
            
            @profile = array('type': 'sqlite', 'file': '/home/minecraft/server/plugins/CommandHelper/policedatabase.sqlite')
            query(@profile, 'DELETE FROM `criminals` WHERE PERPNAME=? AND DATE=?',@plr, @date)
            
            tmsg(@cop, 'Record deleted.');          			
        
        }
    )
)

register_command('removeallrecords', 

    array(
        'description': 'Removes all criminal records for a player',
        'usage': '/removeallrecords <uuid>',
        'permission': 'ch.alias.removeallrecords',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /removeallrecords <uuid>');
                die(); # No need to go further					
            
            }
            
            @uuid = @args[0]			
            @cop = player()                
            
            @profile = array('type': 'sqlite', 'file': '/home/minecraft/server/plugins/CommandHelper/policedatabase.sqlite')
            query(@profile, 'DELETE FROM `criminals` WHERE PERPUUID=?',@uuid)
            
            tmsg(@cop, 'All Records Deleted for UUID: '.@uuid);          			
        
        }
    )
)

register_command('backgroundcheck', 

    array(
        'description': 'Checks for Information on a Player',
        'usage': '/backgroundcheck <player>',
        'permission': 'ch.alias.backgroundcheck',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /backgroundcheck <player>');
                die(); # No need to go further					
            
            }	

            try {
                @plr = player(@args[0])
                @cop = player()
                @uuid = puuid(@plr)
                @ip = pinfo(@plr)[3]
                
                if(has_permission(@cop, 'is.suspended')) {
                    
                        msg(color('RED').color('BOLD').'You are currently suspended! You may not access the Police Database');
                        die();
                    
                }
                
                @profile = array('type': 'sqlite', 'file': '/home/minecraft/server/plugins/CommandHelper/policedatabase.sqlite')
                @result = query(@profile, 'SELECT * FROM `criminals` WHERE PERPUUID=?',@uuid)
                @numOffenses = array_size(@result)
                foreach(@row in @result){
                    tmsg(@cop,
                        color('DARK_RED').'Offense Type: '.@row['TYPE'].color('YELLOW').' | '.
                        color('RED').'Perp Name: '.@row['PERPNAME'].color('YELLOW').' | '.
                        color('GOLD').'Reason: '.@row['REASON'].color('YELLOW').' | '.
                        color('AQUA').'Officer: '.color('DARK_AQUA').@row['AO'].color('YELLOW').' | '.
                        color('GREEN').@row['DATE'])
                    tmsg(@cop,'-----------------------------------------')
                }
                tmsg(@cop,'A total of '.@numOffenses.' warnings and offenses.')	
                
                
            } catch (PlayerOfflineException @ErrorInfo) {
                
                @player = player()
                
                msg(@player,'Player: '.@args[0].' is Offline')
                msg(@player,'Checking Offline Records')
                
                if(has_permission(@player, 'is.suspended')) {
                    
                        msg(color('RED').color('BOLD').'You are currently suspended! You may not access the Police Database');
                        die();
                    
                }
                
                @profile = array('type': 'sqlite', 'file': '/home/minecraft/server/plugins/CommandHelper/policedatabase.sqlite')
                @result = query(@profile, 'SELECT * FROM `criminals` WHERE PERPNAME=?',@args[0])
                @numOffenses = array_size(@result)
                foreach(@row in @result){
                    tmsg(@player,
                        color('DARK_RED').'Offense Type: '.@row['TYPE'].color('YELLOW').' | '.
                        color('RED').'Perp Name: '.@row['PERPNAME'].color('YELLOW').' | '.
                        color('GOLD').'Reason: '.@row['REASON'].color('YELLOW').' | '.
                        color('AQUA').'Officer: '.color('DARK_AQUA').@row['AO'].color('YELLOW').' | '.
                        color('GREEN').@row['DATE'])
                    tmsg(@player,'-----------------------------------------')
                }
                tmsg(@player,'A total of '.@numOffenses.' warnings and offenses.')
                tmsg(@player,'**OFFLINE RECORD**')
                
                die()
            }					
        
        }
    )
)

register_command('criminalrecord', 

    array(
        'description': 'Returns your Criminal Records',
        'usage': '/criminalrecord',
    
        'executor': closure() {            
            
            @plr = player()
            @cop = player()
            @uuid = puuid(@plr)
            @ip = pinfo(@plr)[3]
            
            @profile = array('type': 'sqlite', 'file': '/home/minecraft/server/plugins/CommandHelper/policedatabase.sqlite')
            @result = query(@profile, 'SELECT * FROM `criminals` WHERE PERPUUID=?',@uuid)
            @numOffenses = array_size(@result)
            foreach(@row in @result){
                tmsg(@cop,
                    color('DARK_RED').'Offense Type: '.@row['TYPE'].color('YELLOW').' | '.
                    color('RED').'Perp Name: '.@row['PERPNAME'].color('YELLOW').' | '.
                    color('GOLD').'Reason: '.@row['REASON'].color('YELLOW').' | '.
                    color('AQUA').'Officer: '.color('DARK_AQUA').@row['AO'].color('YELLOW').' | '.
                    color('GREEN').@row['DATE'])
                tmsg(@cop,'-----------------------------------------')
            }
            tmsg(@cop,'A total of '.@numOffenses.' warnings and offenses.')	
            
        }
    )
)

register_command('officerhistory', 

    array(
        'description': 'Checks the Arrest and Warning History of an Officer',
        'usage': '/officerhistory <player>',
        'permission': 'ch.alias.officerhistory',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /officerhistory <player>');
                die(); # No need to go further					
            
            }				

            try {
                @plr = player(@args[0])
                @cop = player()
                @uuid = puuid(@plr)
                @ip = pinfo(@plr)[3]
                
                if(has_permission(@cop, 'is.suspended')) {
                    
                        msg(color('RED').color('BOLD').'You are currently suspended! You may not access the Police Database');
                        die();
                    
                }
                
                @profile = array('type': 'sqlite', 'file': '/home/minecraft/server/plugins/CommandHelper/policedatabase.sqlite')
                @result = query(@profile, 'SELECT * FROM `criminals` WHERE OFFUUID=?',@uuid)
                @numOffenses = array_size(@result)
                foreach(@row in @result){
                    tmsg(@cop,
                        color('DARK_RED').'Offense Type: '.@row['TYPE'].color('YELLOW').' | '.
                        color('RED').'Perp Name: '.@row['PERPNAME'].color('YELLOW').' | '.
                        color('GOLD').'Reason: '.@row['REASON'].color('YELLOW').' | '.
                        color('AQUA').'Officer: '.color('DARK_AQUA').@row['AO'].color('YELLOW').' | '.
                        color('GREEN').@row['DATE'])
                    tmsg(@cop,'-----------------------------------------')
                }
                tmsg(@cop,'A total of '.@numOffenses.' warnings and offenses.')
            } catch (PlayerOfflineException @ErrorInfo) {				
                msg('Player is Offline')				
                die()
            }
        
        }
    )
)

register_command('arrestonjoin', 

    array(
        'description': 'Checks the Arrest and Warning History of an Officer',
        'usage': '/arrestonjoin <player>',
        'permission': 'arrestplayer.onjoin',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /arrestonjoin <player>');
                die(); # No need to go further					
            }				

                @vic = player(@args[0])
                
                sudo('/pex user '.@vic.' add arrest.onjoin')
                msg(color('RED').@vic.' will be arrested the next time they log in.')
        
        }
    )
)
