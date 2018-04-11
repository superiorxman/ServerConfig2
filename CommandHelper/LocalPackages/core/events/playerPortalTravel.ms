bind('player_portal_travel', null, array('to': null), @event){
    cancel()
    set_timeout(50,closure(
        sudo('/mv spawn')
        msg(color('RED').'Sorry, that world does not exist')
    ))
}