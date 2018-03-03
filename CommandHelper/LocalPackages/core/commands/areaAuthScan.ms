register_command('areaAuthScan', 
    array(
        'description': 'checks for the right perms',
        'usage': '/areaauthscan <blockRadius> <permissionToCheck>',
        'permission': 'comand.areaauthscan',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {

            @radius = @args[0]
            @ploc = get_command_block()
            @plrs = players_in_radius(@ploc,@radius)
            @permission = @args[1]

            foreach(@plr in @plrs){
                if(!has_permission(@plr,@permission)){
                    pkill(@plr)
                    broadcast(@plr.color('RED').' was vaporized by the security door. Poof!')
                }
            }
        }
    )
)