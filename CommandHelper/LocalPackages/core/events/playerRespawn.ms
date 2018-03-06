bind('player_spawn', null, null, @event){

    if(has_permission(@player,'tick.kill')){
        set_timeout(50,closure(
            pkill(@player)
        ))
    }

    @player = @event['player']
    set_timeout(1000,closure(
        if(has_permission(@player,'ch.alias.buff') && import(@player.'autoBuffStatus') != false){
            runas(@player,'/buff')
        }
    ))

}
