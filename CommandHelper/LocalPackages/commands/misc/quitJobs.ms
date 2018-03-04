register_command('quitjob', 
    array(
        'description': 'Power',
        'permission': 'command.quitjob',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@aliases, @sender, @args) {

            queue_push(closure(runas('~console','/pex user '.@sender.' remove is.builder')))
            queue_push(closure(runas('~console','/pex user '.@sender.' group remove builder')))

            queue_push(closure(runas('~console','/pex user '.@sender.' remove is.headbuilder')))
            queue_push(closure(runas('~console','/pex user '.@sender.' group remove headbuilder')))
            
            queue_push(closure(runas('~console','/pex user '.@sender.' remove is.police')))
            queue_push(closure(runas('~console','/pex user '.@sender.' group remove police')))
            
            queue_push(closure(runas('~console','/pex user '.@sender.' remove is.headpolice')))
            queue_push(closure(runas('~console','/pex user '.@sender.' group remove headpolice')))
            
            msg(color('RED').'You have quit your job.')
            
        }
    )
)