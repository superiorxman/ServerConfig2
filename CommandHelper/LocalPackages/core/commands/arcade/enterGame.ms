register_command('entergame', 
    array(
        'description': 'Arrests a player and Jails them',
        'usage': '/entergame',
        'permission': 'command.entergame',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
                if (array_size(@args) != 0) {
                    msg(color('RED').'Usage: /entergame')
                    return(false)
                }

                @player = @sender
                @ploc = ploc(@player)
                @center = array('x': -12, 'y': 97, 'z': -12, 'world': @ploc['world'])

                @x1 = @ploc['x']
                @y1 = @ploc['y']
                @z1 = @ploc['z']

                @x2 = @center['x']
                @y2 = @center['y']
                @z2 = @center['z']

                @x3 = pow(@x1 - @x2, 2)
                @y3 = pow(@y1 - @y2, 2)
                @z3 = pow(@z1 - @z2, 2)

                @final = @x3 + @y3 + @z3

                @final = sqrt(@final)
                
                if(@final > 1){
                    msg(color('RED').'Sorry, you are not close enough to the game starting pad!')
                    die()
                }

                @particleType = 'portal'
                @offset = 0.5
                @speed = 0.2
                @count = 5000
                export(@player.'particleIterations',0)
                set_interval(50,closure(
                    @i = import(@player.'particleIterations')
                    play_effect(array('x': @center['x'], 'y': (@center['y'] + 2), 'z': @center['z'], 'world': @ploc['world']), @particleType, array('particleCount': @count, 'offsetX': @offset, 'offsetY': @offset, 'offsetZ': @offset, 'speed': @speed))
                    if(@i >= 20){
                        clear_task()
                        console(@i)
                    }else{
                        @i++
                        console(@i)
                        export(@player.'particleIterations',@i)
                    }
                ))

                die()

                if(import('vrInUse') == true){
                    msg(color('RED').'Sorry, the machine is in use.')
                    die()
                }

                export('vrInUse',true)
                set_block_at(-15, 95, -6, 152, @ploc['world'])

                msg(color('GREEN').'I:O Uplink ON, connecting to Infinity:One ... ')
                set_timeout(1500,closure(
                    msg(color('GREEN').'Connecting ...')
                ))

                set_timeout(3400,closure(
                    @ploc = ploc(@player)

                    @x1 = @ploc['x']
                    @y1 = @ploc['y']
                    @z1 = @ploc['z']

                    @x2 = @center['x']
                    @y2 = @center['y']
                    @z2 = @center['z']

                    @x3 = pow(@x1 - @x2, 2)
                    @y3 = pow(@y1 - @y2, 2)
                    @z3 = pow(@z1 - @z2, 2)

                    @final = @x3 + @y3 + @z3

                    @final = sqrt(@final)
                    
                    if(@final > 1){
                        msg(color('RED').'Uplink canceled, please hold still during uplink process. Please try again.')
			set_block_at(-15, 95, -6, 0, @ploc['world'])
                        export('vrInUse',false)
                        die()
                    }
                    @center['y']++
                    @plrs = players_in_radius(@center,1)
                    @count = array_size(@plrs)
                    @tooManyPlayers = false
                    if(@count == 0){
                        export('vrInUse',false)
                        die()
                    }else if(@count > 1){
                        foreach(@plr in @plrs){
                            if(@plr != @player && pinfo(@plr)[5] > 0){
                                pkill(@plr)
                                @tooManyPlayers = true
                            }
                        }
                        if(@tooManyPlayers){
                            broadcast(color('GREEN').'Reminder, only one person at a time in the I:O Uplink. Thank you.')
                        }
                    }

                    set_peffect(@sender,14,1,9999,true,false)
                    runas('~console','/minecraft:clear '.@sender)
                    runas('~console','/warp begingame '.@sender)
                    broadcast(@sender.color('RED').' is now playing Infinity:One')
                    sudo('/characterselect')
                    set_block_at(-15, 95, -6, 0, @ploc['world'])
                    export('vrInUse',false)
                ))
        }
    )
)
