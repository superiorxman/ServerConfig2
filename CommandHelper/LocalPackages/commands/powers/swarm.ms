register_command('swarm', 
    array(
        'description': 'Power',
        'permission': 'ch.alias.swarm',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',    
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /swarm <player>');
                die(); # No need to go further					
            
            }
            
            @vic = @args[0]
            @vic = player(@vic)
            @player = player()
            
            @ploc = ploc()
            @vicLoc = ploc(@vic)

            @x1 = @ploc['x']
            @y1 = @ploc['y']
            @z1 = @ploc['z']

            @x2 = @vicLoc['x']
            @y2 = @vicLoc['y']
            @z2 = @vicLoc['z']

            @x3 = pow(@x1 - @x2, 2)
            @y3 = pow(@y1 - @y2, 2)
            @z3 = pow(@z1 - @z2, 2)

            @final = @x3 + @y3 + @z3

            @final = sqrt(@final)

            if(@final > 50){
                tmsg(@player,color('RED').'Sorry, you are not close enough to that player!')
                die()
            }

            assign(@cooldown, 60)
            
            assign(@lastUsedSwarm, import(@player."lastUsedSwarm"))
            if(@lastUsedSwarm + @cooldown > time() / 1000,
                assign(@timeleft, subtract(add(@lastUsedSwarm, @cooldown), divide(time(),1000)))
                tmsg(@player,concat('§c[§4', Error, '§c] §7You must wait another §6', round(@timeleft), ' §7seconds before you can use swarm again!'))
                die()
            )
            export(@player."lastUsedSwarm", time() / 1000)
            
            tmsg(@player,color('RED').'You have summoned a mosquito swarm upon '.color('WHITE').@vic.color('RED').'!')
            tmsg(@vic,color('RED').'Oh no! '.color('WHITE').'Mosquito Girl '.color('RED').'has summoned her mosquitos on you!')
            if(ponline(@vic)){

                @eventID1 = set_interval(50,closure(
                    @loc = ploc(@vic)
                    #sudo("/particle largesmoke ".@loc[0]." ".@loc[1]." ".@loc[2]." 0.5 1 0.5 0.01 64")
                    play_effect(@loc, 'LARGE_SMOKE', array('offsetX': 0.5, 'offsetY': 1.0, 'offsetZ': 0.5, 'speed': 0.01, 'particleCount': 64))
                ))
                @eventID2 = set_interval(1000,closure(
                    damage_entity(puuid(@vic),6)        
                ))

                set_timeout(15000,closure(
                    clear_task(@eventID1)
                    clear_task(@eventID2)
                ))

            }
            
        }
    )
)
