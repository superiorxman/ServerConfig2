bind('entity_damage', null, array('type':'/PLAYER/', 'cause': '/ENTITY_ATTACK|CONTACT|PROJECTILE|LIGHTNINIG|FALLING_BLOCK/'), @e) {
   
    if(has_permission(@e['player'], "powers.ultrainstinct"))
    {
        cancel()
        tmsg(@e['player'], color('RED').'Your Ultra Instinct saves you from damage!')
        @ploc = ploc(@e['player'])
        
        for(@i = 0, @i < 10, @i++){
            if(rand(0,2) == 1){
                @xOffset = 1
            }else{
                @xOffset = -1
            }
            
            if(rand(0,2) == 1){
                @zOffset = 1
            }else{
                @zOffset = -1
            }
            @newLoc = array_deep_clone(@ploc)
            @newLoc['x'] = @newLoc['x'] + @xOffset
            @newLoc['z'] = @newLoc['z'] + @zOffset
            @newLoc['y'] = @newLoc['y'] + 1

            if(get_block_at(@newLoc) == '0:0'){
                @newLoc['y'] = @newLoc['y'] + 1
                if(get_block_at(@newLoc) == '0:0' ){
                    @newLoc['y'] = @newLoc['y'] - 2
                    set_ploc(@e['player'],@newLoc)
                    return()
                }
            }
        }
    }
}
