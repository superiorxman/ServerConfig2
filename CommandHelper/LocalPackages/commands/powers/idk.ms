/*register_command('reversetag', 
    array(
        'description': 'Power',
        'permission': '',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) { 

            create_objective('Test')
            create_team('it')
            get_pscore()
            get_pteam()
            set_objective_display('sidebar')
            set_pscore()
            team_add_player()
            team_remove_player()
            
        }
    )
)
*/