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