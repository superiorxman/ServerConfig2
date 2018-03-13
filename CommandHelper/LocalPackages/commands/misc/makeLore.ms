register_command('getnbt', 
    array(
        'description': 'Gives Player their Superhero Powers',
        'usage': '/getnbt',
        'permission': 'command.makelore',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alises, @sender, @args) {
        
            @vic = @args[0]
            @slot = @args[1]
            console(nbt_read_inventory_item(puuid(@vic),@slot))
        }
    )
)
register_command('makelore', 
    array(
        'description': 'Gives Player their Superhero Powers',
        'usage': '/makelore',
        'permission': 'command.makelore',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alises, @sender, @args) {
        
            @lore = @args[0]

            @item = pinv(@sender, null)
            @item['meta'] = array('lore': '')
            @item['meta']['lore'] = @lore
            set_pinv(array(null: @item))

        }
    )
)
register_command('addtolore', 
    array(
        'description': 'Gives Player their Superhero Powers',
        'usage': '/makelore',
        'permission': 'command.makelore',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alises, @sender, @args) {
        
            @lore = @args[0]

            @item = pinv(@sender, null)
            @existingLore = ''
            if(@item['meta'] != null && array_index_exists(@item['meta'],'lore')){
                array_push(@item['meta']['lore'],@lore)
            }else{
                @item['meta'] = array('lore': array(@lore))
            }
            set_pinv(array(null: @item))

        }
    )
)
register_command('viewlore', 
    array(
        'description': 'Gives Player their Superhero Powers',
        'usage': '/makelore',
        'permission': 'command.makelore',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alises, @sender, @args) {

            @item = pinv(@sender, null)
            if(@item['meta'] != null && array_index_exists(@item['meta'],'lore')){
                msg(@item['meta']['lore'])
            }
        }
    )
)
