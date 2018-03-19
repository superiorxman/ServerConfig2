bind('entity_damage',null,array('cause':'/ENTITY_EXPLOSION|BLOCK_EXPLOSION/'),@event){
    
    @id = get_claim_id(entity_loc(@event['id']))
    if(@id != null){
        cancel()
    }
}
