proc('_isSpecialPotion',@item,@launchEventID,@thrower){
    if(@item != null){
        if(is_array(@item['meta'])){
            @itemName = @item['meta']['display']

            if(@itemName == color('DARK_PURPLE').'Joker '.color('WHITE').'Venom'){
                include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
                if(_coolDown('jokervenom',60,@thrower)){
                    die()
                }
                bind('projectile_hit', null, associative_array('id': @launchEventID), @e,@thrower){
                    @players = players_in_radius(@e['location'],8)
                    array_remove_values(@players,@thrower)
                    if(array_size(@players) > 0){
                        foreach(@player in @players){
                            sudo('/freeze '.@player.' 15000')
                            export(@player.'laughingGasActive',true)
                        }
                        @laughInterval = set_interval(1000,closure(
                            @rPlr = array_rand(@players,1,false)[0]
                            @whichHa = rand(0,10)
                            @ha = ''
                            switch(@whichHa){
                                case 0:
                                    @ha = 'ha ha ha ha!'
                                    break()
                                case 1:
                                    @ha = 'HAHA HAHA HAHA!'
                                    break()
                                case 2:
                                    @ha = 'Ha'
                                    break()
                                case 3:
                                    @ha = 'ha ha!'
                                    break()
                                case 4:
                                    @ha = 'HA HA!'
                                    break()
                                case 5:
                                    @ha = 'Ha hA HA!'
                                    break()
                                case 6:
                                    @ha = 'HA HA ha HA!'
                                    break()
                                case 7:
                                    @ha = 'HAHAhahahaAHAHA!'
                                    break()
                                case 8:
                                    @ha = 'HA HA HA HA HA HA HA!'
                                    break()
                                case 9:
                                    @ha = 'ha ha ha ha HA HA HA HA!'
                                    break()
                            }
                            chatas(@rPlr,'laughingGas'.@ha)
                        ))

                        set_timeout(15500,closure(
                            foreach(@player in @players){
                                unbind(@player.'laughingGasActive')
                                tmsg(@player,color('RED').'You can speak again.')
                                clear_task(@laughInterval)
                                export(@player.'laughingGasActive',false)
                            }
                        ))
                    }
                }
                return(true)
            }
        }
    }
    return(false)
}
