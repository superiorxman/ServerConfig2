register_command('requestchar', 

    array(
        'description': 'Request a hero to be made!',
        'usage': '/requestchar <character>',
        'permission': 'command.requestchar',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
            if (array_size(@args) < 1) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /requestchar <character>');
                die()
            }

            @rq = ''
            foreach(@word in @args){
                @rq = @rq.@word.' '
            }
            @rq = trim(@rq)

            @list = get_values('characterrequests.list')
            if(array_index_exists(@list,'characterrequests.list')){
                array_push(@list['characterrequests.list'],@rq.' - '.@sender)
                store_value('characterrequests.list',@list['characterrequests.list'])
            }else{
                store_value('characterrequests.list',array(@rq.' - '.@sender))
            }
            broadcast(@sender.color('RED').' added '.color('WHITE').@rq.color('RED').' to the '.color('GREEN').'/requestchar'.color('RED').' list. See all the requested characters to be added using '.color('GREEN').'/listrequests')
        
        }
    )
)

register_command('listrequests', 

    array(
        'description': 'Request a hero to be made!',
        'usage': '/listrequests [pagenum]',
        'permission': 'command.requestchar',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
            if (array_size(@args) > 1) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /listrequests [pagenum]');
                die()
            }
            if (array_size(@args) == 0) {
                @pageNum = 1
            }else{
                @pageNum = integer(@args[0])
            }
            
            @list = get_values('characterrequests.list')
            if(@pageNum >= 0){
                @indexNum = (@pageNum - 1) * 10
            }else{
                @indexNum = 0
            }
            
            if(array_index_exists(@list,'characterrequests.list')){
                for(@i = @indexNum, @i < (@indexNum + 10), @i++){
                    queue_push(closure(
                        @request = @list['characterrequests.list'][@i]
                        @request = color('YELLOW').replace(@request,' - ',color('WHITE').' - '.color('GREEN'))
                        msg(++@i.'. '.@request)
                    ))
                }
                /*foreach(@request in @list['characterrequests.list']){
                    queue_push(closure(
                        @request = color('YELLOW').replace(@request,' - ',color('WHITE').' - '.color('GREEN'))
                        msg(@num.'. '.@request)
                    ))
                    @num++
                }*/
            }else{
                msg('1. '.@list)
            }
        }
    )
)

register_command('removerequest', 

    array(
        'description': 'Request a hero to be made!',
        'usage': '/removerequest',
        'permission': 'command.removerequest',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
    
        'executor': closure(@alias, @sender, @args) {
            if (array_size(@args) != 1) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /removerequest <number>');
                die()
            }

            @num = @args[0]
            if(is_numeric(@num)){
                @num--
            }else{
                msg(color('RED').'Usage: /removerequest <number>');
                die()
            }

            @list = get_values('characterrequests.list')
            if(array_index_exists(@list,'characterrequests.list')){
                @removed = @list['characterrequests.list'][@num]
                array_remove(@list['characterrequests.list'],@num)
                store_value('characterrequests.list',@list['characterrequests.list'])
                broadcast(color('RED').'Removed '.color('WHITE').@removed)
            }else{
                store_value('characterrequests.list',array())
            }
        }
    )
)

