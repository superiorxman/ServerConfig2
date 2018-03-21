bind('entity_damage', null, array('cause':'ENTITY_ATTACK'), @e) {

    if(!array_index_exists(@e,'damager') || !ponline(@e['damager'])){
        die()
    }
    @attacker = @e['damager']

    @vicID = @e['id']
    @vicName = ''
    if(@e['type'] == 'PLAYER'){
        @vicName = @e['player']
        try(
            @ploc = ploc(@vicName)
        ,
            console('2')
            cancel()
            die()
        )
    }

    if(has_permission(@attacker,'powers.onepunch') && import(@attacker.'isDepowered') != true){
        if(@vicName != ''){
            set_peffect(@vicName,11,1,0)
        }
        modify_event('amount', 9999)
    }
}
