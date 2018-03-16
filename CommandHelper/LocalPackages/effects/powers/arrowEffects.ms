/*bind('projectile_launch', null, array('type': 'ARROW', 'shootertype': 'PLAYER'), @event) {
    @pname = @event['player']
    @shooterType = @event['shootertype']
    @inv = pinv(@pname)
    @arrowUsed = false
    include('/home/minecraft/server/plugins/CommandHelper/includes/isSpecialArrow.ms')
    for(@i = 0, @i <= 35, @i++){
        @isArrowSpecial = _isSpecialArrow(@inv[@i],@event['id'])
        
        if(@isArrowSpecial == 'wwwaaattt'){
            tmsg(@pname,@isArrowSpecial)
            die()
        }
        if(@isArrowSpecial == true){
            @inv[@i]['qty']--
            set_pinv(@pname,@inv)
            die()
        }
    }
    if(_isSpecialArrow(@inv[-106],@event['id'])){
        @inv[-106]['qty']--
        set_pinv(@pname,@inv)
    }

}*/

bind('projectile_launch', null, array('type': 'ARROW', 'shootertype': 'PLAYER'), @event) {
    @pname = @event['player']
    @inv = pinv(@pname)
    include('/home/minecraft/server/plugins/CommandHelper/includes/isSpecialArrow.ms')
    for(@i = 0, @i <= 35, @i++){
        if(_isSpecialArrow(@inv[@i],@event['id'])){
            die()
        }
    }
    if(_isSpecialArrow(@inv[-106],@event['id'])){
        die()
    }

}