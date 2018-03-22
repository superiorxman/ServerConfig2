bind('player_chat', null, null, @e) {
    @player = @e['player']
    include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
    @msg = @e['message']
    @orignalMsg = @e['message']
    @class = _getheroclass(@player)
    @cooldown = 0

    if(@player == 'Txmmeh'){
        @msgg = split(' ',@msg)
        @finMsg = ''
        foreach(@word in @msgg){
            if(to_lower(@word) == 'xp'){
                @word = 'Windows '.@word
            }else if (to_lower(@word) == 'xi'){
                @word = 'Superbowl '.@word
            }
            @finMsg = @finMsg.@word.' '
        }
        modify_event(message,@finMsg)
        @msg = @finMsg
        if(string_position(@msg, ';-;') != -1){
            @pos = string_position(@msg, ';-;')
            @origWord = @msg[@pos].@msg[@pos+1].@msg[@pos+2]
            @word = '(i am a crybaby)'
            @msg = replace(@msg,@origWord,@word)
            modify_event(message,@msg)
        }
    }

    if(import(@player.'mindControlling')){
        cancel()
        die()
    }

    if(import(@player.'laughingGasActive') == true){
        @msg = @e['message']
        if(string_contains(@msg,'laughingGas') == true){
            @msg = replace(@msg,'laughingGas','')
            modify_event('message',@msg)
            die()
        }else{
            tmsg(@player,color('RED').'Sorry, you temporarily cannot speak.')
            cancel()
            die()
        }
    }

    // force lowercase should happen no matter what, so it's 1st
    if(has_permission('case.tolower')){
        @msg = to_lower(@msg)
    }

    if(import(@player.'isMindLocked')){
        @mindLocker = import(@player.'mindLockedBy')
        if(@mindLocker != null && @mindLocker != ''){
            tmsg(@mindLocker,color('DARK_RED').'['.color('RED').'mindlock'.color('DARK_RED').'] '.color('RED').@player.color('DARK_RED').': '.color('GRAY').@msg)
            tmsg(@player,color('DARK_RED').'['.color('RED').'mindlock'.color('DARK_RED').'] '.color('RED').@player.color('DARK_RED').': '.color('GRAY').@msg)
            cancel()
            return()
        }
    }

    @lastCoolDownAmount = import(@player.'lastCoolDownAmount')
    if(@lastCoolDownAmount == null){
        @lastCoolDownAmount = @cooldown
    }
    include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
    if(_coolDown('lastmessage',@lastCoolDownAmount,@player)){
        cancel()
        return()
    }

    try{
        @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@class.'.yml')
        @hero = yml_decode(@contents)
    }catch(Exception @e){
        @hero = array()
    }

    @rand = null
    if(array_index_exists(@hero,'occasionalPhrases') && array_index_exists(@hero,'occasionalPhraseFrequency')){
        @occasionalPhrase = array_rand(@hero['occasionalPhrases'],1,false)[0]
        @freq = @hero['occasionalPhraseFrequency']
        @rand = rand(0,@freq)
    }

    if(array_index_exists(@hero,'allowedPhrases')){
        @msg = array_rand(@hero['allowedPhrases'],1,false)[0]
    }

    if(@rand != null && (@rand + 1) == @freq){
        @msg = @occasionalPhrase
    }


    if(array_index_exists(@hero,'class')){
        @allPlayers = all_players()
        foreach(@plr in @allPlayers){
            @oclass = _getheroclass(@plr)
            try{
                @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@oclass.'.yml')
                @oHero = yml_decode(@contents)
            }catch(Exception @e){
                continue()
            }
            if(array_index_exists(@oHero,'canUnderstand')){
                foreach(@understandable in @oHero['canUnderstand']){
                    if(@understandable == @class){
                        set_timeout(50,closure(
                            tmsg(@plr,@oHero['costumes'][0]['name'].color('RED').' says: '.@orignalMsg)
                        ))
                    }
                }
            }
        }
    }

    if(has_permission(@player.'is.mrmxyzptlk') && string_contains(to_lower(@msg), 'kltpzyxm')){
        sudo('/mainmenu')
        set_timeout(1500, closure(
            tmsg(@player, 'You said your name backwards! Off to the other dimension you go!')
        ))
    }

    // fun shit goes after here
    if(has_permission(@player,'change.chat')){
        @numb = rand(0,2)
        if(@numb == 1){
            @numba = rand(0,21)
            switch(@numba){
                case 0: 
                    @msg = 'God isn\'t real!'
                    break()
                case 1:
                    @msg = 'I don\'t believe in God'
                    break()
                case 2: 
                    @msg = 'How can God be real? It doesn\'t make any sense.'
                    break()
                case 3: 
                    @msg = 'IF GOD IS REAL, SMITE ME! RIGHT NOW!'
                    break()
                case 4: 
                    @msg = 'I don\'t even think Jesus was real'
                    break()
                case 5: 
                    @msg = 'I\'m an athiest, is anyone else not believe in god too?'
                    break()
                case 6: 
                    @msg = 'Only insecure people believe in god'
                    break()
                case 7: 
                    @msg = 'There is no proof of god, its all fake'
                    break()
                case 8: 
                    @msg = 'fuck God, he\'s a total dick'
                    break()
                case 9: 
                    @msg = 'Who killed more people in the bible, god or satan? God did, by like millions'
                    break()
                case 10: 
                    @msg = 'According to the bible, satan is better than god'
                    break()
                case 11: 
                    @msg = 'if you believe in god, it\'s because you are weak minded'
                    break()
                case 12: 
                    @msg = 'god made man in his image? then god is a monkey cuz thats where humans evolved from'
                    break()
                case 13: 
                    @msg = 'heaven isnt real, hell isnt real, god isnt real, the only thing thats real is my misery. fuck god'
                    break()
                case 14: 
                    @msg = 'u know what? priests molest children, did you know that?'
                    break()
                case 15: 
                    @msg = 'Even the POPE says evolution is real'
                    break()
                case 16: 
                    @msg = 'god is a lie that you tell kids to make them believe life is worth living. protip: its not'
                    break()
                case 17: 
                    @msg = 'jesus turned water into wine because he was a fucking alcoholic'
                    break()
                case 18: 
                    @msg = 'god literally raped a woman (mary). she did not consent, that is RAPE'
                    break()
                case 19: 
                    @msg = 'and another thing, why the fuck did god give us free will if he punishes us for using us wrong? CUZ HE\'S A DICK'
                    break()
                case 20: 
                    @msg = 'Oh, hello, I\'m talking to a fucking BURNING BUSH THIS MUST BE GOD, IM NOT ON DRUGS! THIS IS TOTALLY HAPPENING!" ffs...'
                    break()

            }
            @cooldown = 10
            
        }
    }

    // Confusion affects anyone who has specfic allowed phrases, so it comes after
    if(import(@player.'isConfused')){
        @words = split(' ',@msg)
        @numWords = array_size(@words)
        if(@numWords > 1){
            @newWordOrder = array_rand(@words,@numWords,false)
            @newSentence = ''
            foreach(@wd in @newWordOrder){
                @newSentence = @newSentence.@wd.' '
            }
            @msg = @newSentence
        }
    }

    if(has_permission(@player,'chat.tofood')){
        @msg = replace(@msg,'f','food')
        @msg = replace(@msg,'F','FOOD')
    }

    if(has_permission(@player,'chat.tictac')){
        @msg = replace(@msg,'t','tictac')
        @msg = replace(@msg,'T','TICTAC')
    }

    if(has_permission(@player,'chat.ef')){
        @mmm = split(' ',@msg)
        @mod = ''
        foreach(@word in @mmm){
            @word = @word.'ef '
            @mod = @mod.@word
        }
        @msg = @mod
    }

    if(has_permission('chat.babytalk')){
        @msg = replace(@msg,'l','w')
        @msg = replace(@msg,'L','W')
        @msg = replace(@msg,'r','w')
        @msg = replace(@msg,'R','W')
        @msg = replace(@msg,'ee','yee')
        @msg = replace(@msg,'EE','YEE')
        @msg = replace(@msg,'er','yew')
        @msg = replace(@msg,'ER','YEW')
        @msg = replace(@msg,'age','yage')
        @msg = replace(@msg,'AGE','YAGE')
    }


    if(has_permission("is.criminal")){
        @cooldown = 60
    }else if(has_permission('chat.cooldown')){
        @cooldown = 10
    }
    
    export(@player.'lastCoolDownAmount',@cooldown)
    cancel(false)
    modify_event('message',@msg)
    
    
}
