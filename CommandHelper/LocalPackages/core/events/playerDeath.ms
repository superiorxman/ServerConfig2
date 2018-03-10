bind('player_death', null, null, @event){
    @player = @event['player']
    if(has_permission(@player,'tick.kill')){
        modify_event('death_message',null)
        die()
    }

    if(array_index_exists(@event,'cause') && array_index_exists(@event['cause'],'cause') && @event['cause']['cause'] == 'VOID'){
        die()
    }

    @world = pworld()
   
    include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
    @class = _getheroclass(@player)
    @message = @event['death_message']
    try{
        @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
        @hero = yml_decode(@contents)
        @message = replace(@message,@player,@hero['costumes'][0]['name'].color('DARK_RED').color('ITALIC'))
        if(@event['killer'] != null){
            @class = _getheroclass(@event['killer'])
            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                @hero = yml_decode(@contents)
                @message = replace(@message,@event['killer'],@hero['costumes'][0]['name'].color('DARK_RED').color('ITALIC'))
            }catch(Exception @e){
                @message = replace(@message,@player,@player.color('DARK_RED').color('ITALIC'))
            }
        }
    }catch(Exception @e){
        @message = replace(@message,@player,@player.color('DARK_RED').color('ITALIC'))
    }
    modify_event('death_message',@message)
    if(has_permission(@player,'powers.cantdie')){
        set_phealth(@player,1)
        modify_event('death_message',null)
    }

}
