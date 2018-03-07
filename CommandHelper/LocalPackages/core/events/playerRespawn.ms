bind('player_spawn', null, null, @event){
    @player = @event['player']
    if(has_permission(@player,'tick.kill')){
        set_timeout(50,closure(
            pkill(@player)
        ))
        die()
    }

    set_timeout(1000,closure(
        if(has_permission(@player,'ch.alias.buff') && import(@player.'autoBuffStatus') != false){
            runas(@player,'/buff')
        }
        
        include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
        @class = _getheroclass(@sender)
        try{
            @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/' . @class . '.yml')
            @hero = yml_decode(@contents)
        }catch(Exception @d){
            queue_push(closure(set_attribute(@puuid,'maxHealth',20)))    
        }
        @puuid = puuid(@player) 
        if(array_index_exists(@hero,'maxHearts')){
            queue_push(closure(set_attribute(@puuid,'maxHealth',(@hero['maxHearts'] * 2))))
            queue_push(closure(set_phealth(@player,(@hero['maxHearts'] * 2))))
        }else{
            queue_push(closure(set_attribute(@puuid,'maxHealth',20)))
        }
    ))

}
