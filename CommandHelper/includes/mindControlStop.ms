proc('_mindControlStop', @player,  

    @mindControlTimer = import(@player.'mindControlTimer')
    if(@mindControlTimer != null){
        clear_task(@mindControlTimer)
    }

    unbind(@player.'mindControlChatForward')
    unbind(@player.'mindControlPlrLeave')
    unbind(@player.'mindControlVicLeave')
    unbind(@player.'mindControlEntityDamaged')
    unbind(@player.'mindControlDeath')
   
    @ent = import(@player.'mindControlEntityID')
    try{
        entity_remove(@ent)
    }catch(Exception @e){}

    export(@player.'mindControlling',false)

    @vic = import(@player.'mindControlVictim')
    unbind(@vic.'mindControlCommandCancel')
    unbind(@vic.'mindControlTeleportCancel')
    export(@vic.'beingMindControlled',false)

    set_ploc(@vic, ploc(@player))

    @pOrigLoc = import(@player.'mindControlPlayerOrigLocation')
    set_ploc(@player,@pOrigLoc)

    @vicOrigGamemode = import(@player.'mindControlVicOrigGameMode')
    set_pmode(@vic,@vicOrigGamemode)

    @pClass = import(@player.'mindControlPlayerOrigHero')

    @existingForgottenHeroes = import('forgottenHeroes')
    if(is_array(@existingForgottenHeroes)){
        array_remove_values(@existingForgottenHeroes,@pClass)
    }else{
        @existingForgottenHeroes = null
    }
    export('forgottenHeroes',@existingForgottenHeroes)

    @pInv = import(@player.'mindControlPlayerInv')
    @vInv = pinv(@player)
    set_pinv(@vic,@vInv)
    set_pinv(@player,@pInv)

    runas('~console','/pex user '.@player.' group set '.@pClass)
    runas('~console','/sudo '.@player.' c:/fixskin')
    sudo('/buff')

    tmsg(@vic,color('RED').'You are no longer being mind controlled by '.@player)
    tmsg(@player,color('RED').'You are no longer mind controlling '.@vic)
)

proc('_mindControlStopPlayer', @player,  

    @mindControlTimer = import(@player.'mindControlTimer')
    if(@mindControlTimer != null){
        clear_task(@mindControlTimer)
    }

    @controller = import(@player.'beingMindControlledBy')
    @isActive = import(@player.'mindControlActive')

    export(@player.'beingMindControlled',false)
    export(@player.'beingMindControlledBy',null)
    unbind(@player.'mindControlChatForward')
    unbind(@player.'mindControlVicLeave')
    unbind(@player.'mindControlEntityDamaged')
    unbind(@player.'mindControlVicDeath')
    unbind(@player.'mindControlCommandCancel')
    unbind(@player.'mindControlTeleportCancel')
    
    @ent = import(@player.'markerUUID')
    try{
        @entLoc = entity_loc(@ent)
        set_ploc(@player, @ent)
        entity_remove(@ent)
    }catch(Exception @e){}

    if(@isActive){
        @pOrigLoc = import(@controller.'mindControlPlayerOrigLocation')
        set_ploc(@controller,@pOrigLoc)
        
        @pClass = import(@player.'mindControlVicOrigHero')
        @existingForgottenHeroes = import('forgottenHeroes')
        if(is_array(@existingForgottenHeroes)){
            array_remove_values(@existingForgottenHeroes,@pClass)
        }else{
            @existingForgottenHeroes = null
        }
        export('forgottenHeroes',@existingForgottenHeroes)
    }

    @vicOrigGamemode = import(@player.'mindControlVicOrigGameMode')
    set_pmode(@player,@vicOrigGamemode)



    @pInv = import(@player.'mindControlPlayerInv')
    @vInv = pinv(@player)
    set_pinv(@vic,@vInv)
    set_pinv(@player,@pInv)

    runas('~console','/pex user '.@player.' group set '.@pClass)
    runas('~console','/sudo '.@player.' c:/fixskin')
    sudo('/buff')

    tmsg(@vic,color('RED').'You are no longer being mind controlled by '.@player)
    tmsg(@player,color('RED').'You are no longer mind controlling '.@vic)
)
