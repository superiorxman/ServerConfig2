register_command('drown', 

    array(
        'description': 'Roll the Dice. Play the Lottery',
        'usage': '/drown <player>',
        'permission': 'power.drown',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            if(array_size(@args) != 1){
                msg(color('RED').'Usage: /drown <player>')
                die()
            }

            @vic = @args[0]
            @vic = player(@vic)

            set_entity_air(puuid(@vic),0)

            @pos1 = ploc(@vic)

            @pos2 = array_deep_clone(@pos1)
            @pos2['y'] = @pos2['y'] + 5

            @pos1['x'] = @pos1['x'] + 2
            @pos1['z'] = @pos1['z'] + 2

            @pos2['x'] = @pos2['x'] - 2
            @pos2['z'] = @pos2['z'] - 2

            @blocksChanged = array()

            for(@x = min(@pos1['x'],@pos2['x']), @x <= max(@pos1['x'], @pos2['x']), @x++){
                for(@y = min(@pos1['y'],@pos2['y']), @y <= max(@pos1['y'], @pos2['y']), @y++){
                    for(@z = min(@pos1['z'],@pos2['z']), @z <= max(@pos1['z'], @pos2['z']), @z++){
                        @oldBlock = get_block_at(@x,@y,@z,@pos1['world'])
                        if(@oldBlock == '0:0'){
                            @block = array('x': @x,'y': @y,'z': @z,'world': @pos1['world'])
                            set_block_at(@block,9,false)
                            array_push(@blocksChanged,@block)
                        }
                    }
                }
            }

            export(@vic.'waterBlocksSaved',@blocksChanged)

            bind('player_move',array('id': @vic.'drowningPower'),array('player': @vic),@event){
                
                @pos1 = ploc(@event['player'])

                @pos2 = array_deep_clone(@pos1)
                @pos2['y'] = @pos2['y'] + 5

                @pos1['x'] = @pos1['x'] + 2
                @pos1['z'] = @pos1['z'] + 2

                @pos2['x'] = @pos2['x'] - 2
                @pos2['z'] = @pos2['z'] - 2


                @blocksSaved = import(@event['player'].'waterBlocksSaved')
                if(is_array(@blocksSaved)){
                    foreach(@blk in @blocksSaved){
                        set_block_at(@blk,0,false)
                    }
                    export(@event['player'].'waterBlocksSaved',null)
                }

                @blocksChanged = array()

                for(@x = min(@pos1['x'],@pos2['x']), @x <= max(@pos1['x'], @pos2['x']), @x++){
                    for(@y = min(@pos1['y'],@pos2['y']), @y <= max(@pos1['y'], @pos2['y']), @y++){
                        for(@z = min(@pos1['z'],@pos2['z']), @z <= max(@pos1['z'], @pos2['z']), @z++){
                            @oldBlock = get_block_at(@x,@y,@z,@event['world'])
                            if(@oldBlock == '0:0'){
                                @block = array('x': @x,'y': @y,'z': @z,'world': @event['world'])
                                set_block_at(@block,9,false)
                                array_push(@blocksChanged,@block)
                            }
                        }
                    }
                }

                export(@event['player'].'waterBlocksSaved',@blocksChanged)

            }
            set_timeout(10000,closure(
                unbind(@vic.'drowningPower')
                @blocksSaved = import(@vic.'waterBlocksSaved')
                if(is_array(@blocksSaved)){
                    foreach(@blk in @blocksSaved){
                        set_block_at(@blk,0,false)
                    }
                    export(@event['player'].'waterBlocksSaved',null)
                }
            ))
        }
    )
)
register_command('lightfixstop', 

    array(
        'description': 'Roll the Dice. Play the Lottery',
        'usage': '/roll',
        'permission': 'command.lightfixstop',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {
            unbind(@sender.'lightFixBind')
        }
    )
)
