bind('player_quit',null,null,@event){
    @player = @event['player']

    @eventID = import(@player."isVibrating")
    clear_task(@eventID)

    @winner = import(@player.'fcvs')
    if(@winner != '' && @winner != null){
        include('/home/minecraft/server/plugins/CommandHelper/includes/fightClubReset.ms')
        _fightClubReset(@winner,@player)
    }

    @isMindLocked = import(@player.'isMindLocked')
    if(@isMindLocked){
        @vic = import(@player.'mindLockedBy')
        export(@vic.'isMindLocked',false)
        export(@vic.'mindLockedBy','')
        export(@player.'isMindLocked',false)
        export(@player.'mindLockedBy','')
        tmsg(@player,color('RED').'Mindlock connection lost.')
        tmsg(@vic,color('RED').'Mindlock connection lost.')
    } 
    if(has_permission(@player,'tick.kill')){
        runas('~console','/stoptorture')
    }

    @it = import('it')
    if(@it != null && @player == @it){
        @players = all_players()
        array_remove_values(@players,@player)
        foreach(@slot:@plr in @players){
            if(has_permission(@plr,'is.criminal')){
                array_remove(@players,@slot)
            }
        }
        @randName = array_rand(@players)
        @randName = @players[@randName[0]]
        //@it = array(@players[@randName[0]],time())
        export('it',@randName)
        broadcast(color('GRAY').color('ITALIC').@player.' quit, so now '.@randName.' is IT! Don\'t get tagged! You get points for being IT!')
        broadcast(color('GRAY').color('ITALIC').'Do '.color('GREEN').'/whosit'.color('GRAY').color('ITALIC').' to find them!')
    }
}
