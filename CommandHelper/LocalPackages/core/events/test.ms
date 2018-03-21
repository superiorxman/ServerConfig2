proc(_extractValue, @pages, @key,

    foreach(@page in @pages){
        @strPos = string_position(@page,@key.':')
        if(@strPos != -1){
            @val = substr(@page,length(@key.':') + 1)
            @keyVal = array(@key,@val)
            return(@keyVal)
        }
    }
    return(null)
)

register_command(createhero, 
    array(   
        description: 'Generates a Hero using parameters within a book',        
        usage: '/createhero',
        permission: 'essentials.copybook',
        noPermMsg: 'Sorry you don\'t have permission to use this command.',
        executor: closure(@alias, @sender, @args) {   
            
            @itemInHand = pinv(@sender,null);
			
            if(array_index_exists(@itemInHand,'meta') && @itemInHand['meta'] != null && array_index_exists(@itemInHand['meta'],'pages')){
                @pages = @itemInHand['meta']['pages'];     
                @hero_name = _extractValue(@pages, "name");
                if(@hero_name != null){
                    msg('key is '.@hero_name[0])
                    msg('val is '.@hero_name[1])
                }else{
                    msg('Sorry, that is not a properly formatted book')
                }
            }else{
                msg('Sorry, that is not a properly formatted book')
            }
        }
    )
)