bind('block_from_to',null,null,@event){
    cancel()
    switch(@event['location']['world']){
        case 'survival112':
        case 'infiniteparkour':
        case 'survival112_nether':
        case 'survival112_the_end':
            cancel(false)
    }
}
