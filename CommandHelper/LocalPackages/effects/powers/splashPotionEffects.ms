bind('projectile_launch', null, array('type': 'SPLASH_POTION', 'shootertype': 'PLAYER'), @event) {
    @pname = @event['player']
    @inv = pinv(@pname)
    include('/home/minecraft/server/plugins/CommandHelper/includes/isSpecialPotion.ms')
    for(@i = 0, @i <= 35, @i++){
        if(_isSpecialPotion(@inv[@i],@event['id'],@pname)){
            die()
        }
    }
    if(_isSpecialPotion(@inv[-106],@event['id'],@pname)){
        die()
    }
}