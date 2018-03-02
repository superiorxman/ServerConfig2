bind(hanging_break,null,array('type': '/ITEM_FRAME|PAINTING/'),@e){
        cancel()
        //if(@e['player'] != null && has_permission(@e['player'],'cancel.entityclicks') == false && pmode(@e['player']) != 'ADVENTURE'){
        if(@e['player'] != null && has_permission(@e['player'],'cancel.entityclicks') == false){
            /*console('dead from hanging break')
            console(@e['location'])
            entity_remove(@e['id'])
            die()*/
            cancel(false)
        }else if(@e['cause'] == 'PHYSICS'){
            cancel(false)
            /*entity_remove(@e['id'])
            if(@e['type'] == 'PAINTING'){
                @num = '321'
            }else{
                @num = '389'
            }
            @item = array('type':@num, 'data':0, 'qty': 1)
            console(@e)
 
            drop_item(@e['location'],@item)*/
        }
}
bind(player_interact_at_entity,null,null,@e){
    cancel()
    //if(has_permission(@e['player'],'cancel.entityclicks') == false && pmode(@e['player']) != 'ADVENTURE'){
    if(has_permission(@e['player'],'cancel.entityclicks') == false){
        /*console('dead from player interact at entity')
        console(@e['player'])
        die()*/
        cancel(false)
    }
    
}
bind(player_interact_entity,null,array('clicked':'ITEM_FRAME'),@e){
    cancel()
    //if(has_permission(@e['player'],'cancel.entityclicks') == false && pmode(@e['player']) != 'ADVENTURE'){
    if(has_permission(@e['player'],'cancel.entityclicks') == false){
        /*console('dead from player interact')
        console(@e['player'])
        die()*/
        cancel(false)
    }
}
bind(entity_damage,null,array('type':'/ARMOR_STAND|ITEM_FRAME|PAINTING|MINECART|CHEST_MINECART|TNT_MINECART|FURNACE_MINECART|HOPPER_MINECART/'),@e){
    cancel()
    if(array_index_exists(@e,'damager')){
        //if(has_permission(@e['damager'],'cancel.entityclicks') == false && pmode(@e['damager']) != 'ADVENTURE'){
        if(has_permission(@e['damager'],'cancel.entityclicks') == false){
            /*console('dead from damage entity')
            console(@e['location'])
            entity_remove(@e['id'])
            die()*/
            cancel(false)
        }
    }
}
bind(vehicle_destroy,null,null,@e){
    cancel()
    //if(array_index_exists(@e, 'damager') && has_permission(@e['damager'],'cancel.entityclicks') == false && pmode(@e['player']) != 'ADVENTURE'){
    if(array_index_exists(@e, 'damager') && has_permission(@e['damager'],'cancel.entityclicks') == false){
        /*console('dead from vehicle destroy')
        entity_remove(@e['vehicle'])
        console(@e['location'])
        die()*/
        cancel(false)
    }
}
bind(block_dispense,null,null,@e){
    if(@e['item'] == null){
        die()
    }
    cancel()

    @itemType = @e['item']['type']
    switch(@itemType){
        case '310':
        case '311':
        case '312':
        case '313':
        case '298':
        case '290':
        case '300':
        case '301':
        case '306':
        case '307':
        case '308':
        case '309':
        case '314':
        case '315':
        case '316':
        case '317':
        case '302':
        case '303':
        case '304':
        case '305':
        case '443':
        case '442':
        case '397':
            die()
    }

    if(
        @e['location']['world'] == 'survival112' || 
        @e['location']['world'] == 'survival112_nether' || 
        @e['location']['world'] == 'survival112_the_end'
    ){
        cancel(false)
    }
}

bind(inventory_drag,null,null,@e){
    if(@e['oldcursoritem']['type'] == '397'){
        foreach(@slot in @e['slots']){
            console(@slot)
            if(@slot == 39){
                cancel()
                return()
            }
        }
    }
}

bind(inventory_click,null,null,@e){
    if(@e['slotitem'] != null){
        if(@e['slotitem']['type'] == '397' && @e['shiftclick'] == true){
            cancel()
        }
        if(array_index_exists(@e['slotitem'],'enchants')){
            foreach(@enchant in @e['slotitem']['enchants']){
                if(@enchant['etype'] == 'FROST_WALKER'){
                    modify_event('slotitem',null)
                    tmsg(@e['player'], color(RED).'Sorry, frost walker is not allowed, that item has been removed.')
                }
            }
        }else{
            if(array_index_exists(@e,'cursoritem')){
                if(array_index_exists(@e,'slottype')){
                    if(@e['cursoritem']['type'] == '397' && @e['slottype'] == 'ARMOR'){
                        cancel()
                    }
                }
            }
        }
    }
}

bind(player_interact, null, array(button: 'right'), @e){
    if(@e['action'] == 'right_click_air'){
        @meta = get_itemmeta(@e['player'], null)
        if(@meta != null && is_array(@meta['enchants'])){
            @item = pinv(@e['player'],null)
            if(@item['type'] == '397'){
                cancel()
            }
            if(@item['type'] == 301 || @item['type'] == 305 || @item['type'] == 309 || @item['type'] == 313 || @item['type'] == 317){
                foreach(@enchant in @meta['enchants']){
                    if(@enchant['etype'] == 'FROST_WALKER'){
                        @enchant['elevel'] = 0
                    }
                }
                set_itemmeta(@e['player'], null, @meta)
            }
        }
    }
}
