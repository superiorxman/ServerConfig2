register_command('tournamentleave', 

    array(
    
        'description': 'Leaves a joined tournament',
        'usage': '/tournamentleave <tournamentName> <playerName>',
        'permission': 'tournament.leave',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',

        'executor': closure(@alias, @sender, @args) {
         
            @plr = player()
            assign(@cooldown, 15)
            assign(@lastUsedTournamentLeave, import(@plr."lastUsedTournamentLeave"))
            if(@lastUsedTournamentLeave + @cooldown > time() / 1000,
                assign(@timeleft, subtract(add(@lastUsedTournamentLeave, @cooldown), divide(time(),1000)))
                tmsg(@plr,concat('§c[§4', Error, '§c] §7You must wait another §6', round(@timeleft), ' §7seconds before you can leave another tournament!'))
                die()
            )
            if (array_size(@args) > 2) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /tournamentleave <touranmentName>');
                die();					
            }
            if (array_size(@args) < 1) {
                msg(color('RED').color('BOLD').'Improper Usage!');
                msg(color('RED').'Usage: /tournamentleave <touranmentName>');
                die();			
            }
            
            @personLeaving = @plr
            @puuid = puuid(@plr,true)
            @tournamentName = to_lower(@args[0])
            @tournamentURL = @tournamentName.'_omnivs'
            @participantID = get_value('tournament.'.@puuid.@tournamentName.'participantID')

            include('/home/minecraft/server/plugins/CommandHelper/includes/challongeKey.ms')

            @tournamentOwner = get_value('tournament.'.@tournamentName.'tournamentOwner')
            if(@puuid != @tournamentOwner){
                msg(color('RED').'Sorry, it doesn\'t look like you\'re the owner of that tournamnet!')
                die()
            }
            if(array_index_exists(@args,1)){
                @personLeaving = @args[1]
            }

            try{
                @personLeaving = player(@personLeaving)
            }catch(PlayerOfflineException @e){
            }catch(LengthException @e){
                msg(color('RED').'That name is too long!')
                die()
            }

            @url = 'https://api.challonge.com/v1/tournaments/'.@tournamentURL.'/participants.json'
            http_request(@url, array(
                'method': 'GET',
                'headers': array(
                    'Content-Type': 'application/json'
                ),
                'params': array(
                    'api_key': @challongeKey,
                    'state': 'open',
                ),
                'success': closure(@response){
                    if(@response['responseCode'] != 200){
                        tmsg(@plr,@response) 
                        tmsg(@plr,color('RED').'Error!')
                        @error = json_decode(@response['body'])
                        foreach(@error in @error['errors']){
                            tmsg(@plr,color('RED').@error)
                        }
                        die()
                    }
                    @participants = json_decode(@response['body'])
                    @confirmedPerson = false
                    foreach(@participant in @participants){
                        if(@personLeaving == @participant['participant']['costumes'][0]['name']){
                            @confirmedPerson = true
                            @participantID = @participant['participant']['id']
                            break()
                        }
                    }

                    if(!@confirmedPerson){
                        msg(color('RED').'Sorry, we can\'t find that player in that tournament! Make sure you spell their name EXACTLY if they are not online!')
                        die()
                    }

                    @url = 'https://api.challonge.com/v1/tournaments/'.@tournamentURL.'/participants/'.@participantID.'.json'
                    http_request(@url, array(
                        'method': 'POST',
                        'headers': array(
                            'Content-Type': 'application/json'
                        ),
                        'params': array(
                            'api_key': @challongeKey,
                            '_method': 'delete',
                        ),
                        'success': closure(@response5){
                            if(@response5['responseCode'] != 200){
                                tmsg(@plr,@response5) 
                                tmsg(@plr,color('RED').'Error!')
                                @error = json_decode(@response5['body'])
                                foreach(@error in @error['errors']){
                                    tmsg(@plr,color('RED').@error)
                                }
                                die()
                            }
                            @person = json_decode(@response5['body'])['participant']
                            @puuid = @person['misc']
                            tmsg(@plr,@personLeaving.color('RED').' has been removed!')
                            store_value('tournament.'.@puuid.@tournamentName.'participantID','')
                            export(@plr."lastUsedTournamentLeave", time() / 1000)
                        }
                        
                    ))
                }
            ))
        }
    )
)
