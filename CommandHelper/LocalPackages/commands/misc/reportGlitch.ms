register_command('reportglitch', 

    array(
        'description': 'Request a hero to be made!',
        'usage': '/reportglitch <description>',
        'permission': 'command.reportglitch',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
            if (array_size(@args) < 1) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /reportglitch <description>');
                die()
            }

            @rq = ''
            foreach(@word in @args){
                @rq = @rq.@word.' '
            }
            @rq = trim(@rq)

            @list = get_values('reportglitch.list')
            if(array_index_exists(@list,'reportglitch.list')){
                array_push(@list['reportglitch.list'],@rq.' - '.@sender)
                store_value('reportglitch.list',@list['reportglitch.list'])
            }else{
                store_value('reportglitch.list',array(@rq.' - '.@sender))
            }
            broadcast(@sender.color('RED').' reported the glitch '.color('WHITE').@rq.color('RED').' using '.color('GREEN').'/reportglitch')
        
        }
    )
)

register_command('listglitches', 

    array(
        'description': 'Request a hero to be made!',
        'usage': '/listglitches',
        'permission': 'command.requestchar',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
            if (array_size(@args) > 0) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /listglitches');
                die()
            }

            @list = get_values('reportglitch.list')
            @num = 1
            if(array_index_exists(@list,'reportglitch.list')){
                foreach(@request in @list['reportglitch.list']){
                    queue_push(closure(
                        @request = color('YELLOW').replace(@request,' - ',color('WHITE').' - '.color('GREEN'))
                        msg(@num.'. '.@request)
                    ))
                    @num++
                }
            }else{
                msg('1. '.@list)
            }
        }
    )
)

register_command('removeglitch', 

    array(
        'description': 'Request a hero to be made!',
        'usage': '/removeglitch <number>',
        'permission': 'command.removeglitch',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
            if (array_size(@args) != 1) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /removeglitch <number>');
                die()
            }

            @num = @args[0]
            if(is_numeric(@num)){
                @num--
            }else{
                msg(color('RED').'Usage: /removeglitch <number>');
                die()
            }

            @list = get_values('reportglitch.list')
            if(array_index_exists(@list,'reportglitch.list')){
                @removed = @list['reportglitch.list'][@num]
                array_remove(@list['reportglitch.list'],@num)
                store_value('reportglitch.list',@list['reportglitch.list'])
                broadcast(color('RED').'Removed '.color('WHITE').@removed)
            }else{
                store_value('reportglitch.list',array())
            }
        }
    )
)

