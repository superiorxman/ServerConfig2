/*proc('_mindControlStop', @player,  

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

    @pOrigLoc = import(@player.'mindControlOrigLocation')
    set_ploc(@player,@pOrigLoc)

    @OrigGamemode = import(@player.'mindControlOrigGameMode')
    set_pmode(@vic,@OrigGamemode)

    @pClass = import(@player.'mindControlOrigHero')

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
)*/

proc('_mindControlStopPlayer', @player,  

    @mindControlTimer = import(@player.'mindControlTimer')
    if(@mindControlTimer != null){
        clear_task(@mindControlTimer)
    }

    @controller = import(@player.'beingMindControlledBy')
    @isActive = import(@player.'mindControlActive')

    export(@player.'beingMindControlled',false)
    export(@player.'beingMindindControlledBy',null)
    unbind(@player.'mindControlChatForward')
    unbind(@player.'mindControlVicLeave')
    unbind(@player.'mindControlEntityDamaged')
    unbind(@player.'mindControlVicDeath')
    unbind(@player.'mindControlVicCommandCancel')
    
    @ent = import(@player.'markerUUID')
    @entLoc = ''
    try{
        @entLoc = entity_loc(@ent)
        set_ploc(@player, @entLoc)
        entity_remove(@ent)
    }catch(Exception @e){}

    if(@isActive){
        @markerUUID = import(@controller.'markerUUID')
        @pOrigLoc = entity_loc(@markerUUID)
        set_ploc(@controller,@pOrigLoc)
        
        @pClass = import(@player.'mindControlOrigHero')
        @existingForgottenHeroes = import('forgottenHeroes')
        if(is_array(@existingForgottenHeroes)){
            array_remove_values(@existingForgottenHeroes,@pClass)
        }else{
            @existingForgottenHeroes = null
        }
        export('forgottenHeroes',@existingForgottenHeroes)
    }

    @OrigGamemode = import(@player.'mindControlOrigGameMode')
    set_pmode(@player,@OrigGamemode)
    export(@player.'mindControlOrigGameMode',null)



    //@pInv = import(@player.'mindControlPlayerInv')
    //@vInv = pinv(@player)
    //set_pinv(@vic,@vInv)
    //set_pinv(@player,@pInv)
    
    //runas('~console','/pex user '.@player.' group set '.@pClass)
    runas('~console','/sudo '.@player.' c:/fixskin')
    //sudo('/buff')

    tmsg(@player,color('RED').'You are no longer being mind controlled.')
)

proc('_mindControlStop', @player,

    @mindControlTimer = import(@player.'mindControlTimer')
    if(@mindControlTimer != null){
        clear_task(@mindControlTimer)
    }

    @markerUUID = import(@player.'markerUUID')
    if(@markerUUID != null){
        @loc = entity_loc(@markerUUID)
        set_ploc(@player,@loc)
        entity_remove(@markerUUID)
    }
    export(@player.'markerUUID',null)
    
    @pOrigClass = import(@player.'mindControlOrigHero')
    if(@pOrigClass != null){
        runas('~console','/pex user '.@player.' group set '.@pOrigClass)
    }
    export(@player.'mindControlOrigHero',null)
    
    @pOrigGamemode = import(@player.'mindControlOrigGamemode')
    if(@pOrigGamemode != null){
        set_pmode(@player,@pOrigGamemode)
    }
    export(@player.'mindControlOrigGamemode',null)

    @pInv = import(@player.'mindControlInventory')
    if(@pInv != null){
        set_pinv(@player,@pInv)
    }
    export(@player.'mindControlInventory',null)
    unbind(@player.'mindControlChatForward')
    unbind(@player.'mindControlEntityDamaged')
    unbind(@player.'mindControlPlrLeave')
    unbind(@player.'mindControlPlrDeath')
    export(@player.'markerUUID',null)
    export(@player.'mindControlling',null)
    export(@player.'mindControlActiveVic',null)
    runas('~console','/pex user '.@player.' remove powers.mindcontrol superherocity')

    @successfulVics = import(@player.'mindControlVics')

    if(is_array(@successfulVics)){
        console(@successfulVics)
        foreach(@vic in @successfulVics){
            export(@vic.'beingMindControlled',null)
            export(@vic.'beingMindindControlledBy',null)
            unbind(@vic.'mindControlVicLeave')
            unbind(@vic.'mindControlEntityDamaged')
            unbind(@vic.'mindControlVicDeath')
            unbind(@vic.'mindControlVicCommandCancel')

            @OrigGamemode = import(@vic.'mindControlOrigGameMode')
            console(@OrigGamemode)
            console(@vic)
            set_pmode(@vic,@OrigGamemode)
            export(@vic.'mindControlOrigGameMode',null)

            @ent = import(@vic.'markerUUID')
            try{
                @entLoc = entity_loc(@ent)
                set_ploc(@vic, @entLoc)
                entity_remove(@ent)
            }catch(Exception @e){}
            
        }
    }else{
        @successfulVics = all_players()
        foreach(@vic in @successfulVics){
            export(@vic.'beingMindControlled',null)
            export(@vic.'beingMindindControlledBy',null)
            unbind(@vic.'mindControlVicLeave')
            unbind(@vic.'mindControlEntityDamaged')
            unbind(@vic.'mindControlVicDeath')
            unbind(@vic.'mindControlVicCommandCancel')

            export(@vic.'mindControlOrigGameMode',null)
            set_pmode(@vic,'SURVIVAL')

            @ent = import(@vic.'markerUUID')
            try{
                @entLoc = entity_loc(@ent)
                set_ploc(@vic, @entLoc)
                entity_remove(@ent)
            }catch(Exception @e){}
        }
    }
    export(@player.'successfulVics',null)
    runas('~console','/sudo '.@player.' c:/fixskin')
    runas('~console','/effect '.@player.' clear')
    runas(@player,'/effects')
    if(has_permission(@player,'essentials.fly')){
        sudo('/fly on')
    }else{
        sudo('/fly off')
    }
    

)