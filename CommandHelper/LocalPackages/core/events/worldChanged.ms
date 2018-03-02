bind(world_changed, null, null, @event,

    @player = player()

    set_timeout(1000,closure(
        set_pflight(@player,false)
        include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
        @class = _getheroclass(@player)
        if(@class == 'mortal' || has_permission(@player,'is.fanfic')){
            runas(~console,'/undisguiseplayer '.@player)
        }else{
            @skinNum = import(@player.'skinNum')
            if(@skinNum != null){
                runas(@player,'/skin '.@skinNum)
            }
        }
    ))

)
