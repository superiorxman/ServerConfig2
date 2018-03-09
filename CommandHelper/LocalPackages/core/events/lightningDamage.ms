bind('entity_damage',null,array('cause':'/LIGHTNING/'),@event){
    
    @id = get_claim_id(entity_loc(@event['id']))
    if(@id != null){
        cancel()
    }
}
