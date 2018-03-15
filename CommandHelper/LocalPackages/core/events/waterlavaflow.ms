bind('block_from_to',null,null,@event){
    cancel()
    switch(@event['world']){
        case 'survival112':
        case 'survival112_nether':
        case 'survival112_the_end':
            cancel(false)
    }
}
