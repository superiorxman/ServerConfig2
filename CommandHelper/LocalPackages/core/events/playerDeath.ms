bind('player_death', null, null, @event){

    if(@event['cause']['cause'] == 'VOID'){
        die()
    }

    @player = @event['player']
    @world = pworld()
   
    include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
    @class = _getheroclass(@player)
    @message = @event['death_message']
    try{
        @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
        @hero = yml_decode(@contents)
        @message = replace(@message,@player,@hero['name'].color('DARK_RED').color('ITALIC'))
        if(@event['killer'] != null){
            @class = _getheroclass(@event['killer'])
            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
                @hero = yml_decode(@contents)
                @message = replace(@message,@event['killer'],@hero['name'].color('DARK_RED').color('ITALIC'))
                modify_event('death_message',@message)
            }catch(Exception @e){
                @message = replace(@message,@event['player'],@event['player'].color('DARK_RED').color('ITALIC'))
                modify_event('death_message',@message)
            }
        }
    }catch(Exception @e){
        @message = replace(@message,@event['player'],@event['player'].color('DARK_RED').color('ITALIC'))
        modify_event('death_message',@message)
    }
    if(has_permission(@player,'powers.cantdie')){
        set_phealth(@player,1)
        modify_event('death_message',null)
    }

}
