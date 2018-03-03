bind('player_teleport', null, null, @event,
    if(@event['type'] == 'SPECTATE'){
        cancel()
        tmsg(player(),color('RED')."Your character does not have the teleport ability.")
        return()
    }
)
