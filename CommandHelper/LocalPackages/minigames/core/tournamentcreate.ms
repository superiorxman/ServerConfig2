register_command('tournamentcreate', 

    array(
    
        'description': 'Create a tournament',
        'usage': '/tournamentcreate <tournamentName>',
        'permission': 'tournament.create',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',

        'executor': closure(@alias, @sender, @args) {

            @plr = player()
            assign(@cooldown, 60)
            assign(@lastUsedTournamentCreate, import(@plr."lastUsedTournamentCreate"))
            if(@lastUsedTournamentCreate + @cooldown > time() / 1000,
                assign(@timeleft, subtract(add(@lastUsedTournamentCreate, @cooldown), divide(time(),1000)))
                tmsg(@plr,concat('§c[§4', Error, '§c] §7You must wait another §6', round(@timeleft), ' §7seconds before you can create another tournament!'))
                die()
            )

            if (array_size(@args) != 1) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /tournamentcreate <tournamentName>');
                die(); 
            }

            @tournamentName = to_lower(@args[0])

            include('/home/minecraft/server/plugins/CommandHelper/includes/challongeKey.ms')

            @url = 'https://api.challonge.com/v1/tournaments.json'
            @puuid = puuid(@plr,true)
            @prevTourn = get_value('tournament.'.@puuid.'tournamentOwned')
            if(@prevTourn != null && @prevTourn != ''){
                msg(color('RED').'Sorry, you are already running a different tournament! Please first do /tournamentdelete '.@prevTourn)
                die()
            }
            tmsg(@plr,color('RED').'Creating tournament...')
            http_request(@url, array(
                'method': 'POST',
                'headers': array(
                    
                 'Content-Type': 'application/json'
                ),   'params': array(
                 'api_key': @challongeKey,
                 'tournament[name]': @tournamentName,
                 'tournament[url]': @tournamentName.'_omnivs',
                 'tournament[tournament_type]': 'double elimination',
                ),
                'success': closure(@response){
                if(@response['responseCode'] != 200){
                    tmsg(@plr,color('RED').'Error!')
                    @error = json_decode(@response['body'])
                    foreach(@error in @error['errors']){
                        if(@error == 'URL has already been taken'){
                            tmsg(@plr,color('RED').'Name has already been taken')
                        }else{
                            tmsg(@plr,color('RED').@error)
                        }
                    }
                    die()
                }
                @tournamentInfo = json_decode(@response['body'])
                store_value('tournament.'.@puuid.'tournamentOwned',@tournamentName)
                store_value('tournament.'.@tournamentName.'tournamentOwner',@puuid)
                broadcast(color('RED').'Tournament '.@tournamentName.' is now taking signups!'.color('WHITE').' /tournamentjoin '.@tournamentName)
                export(@plr."lastUsedTournamentCreate", time() / 1000)
            }));
        }
    )
)
