proc('_changeSkin', @plr, @sig, @val, @heroName,

    if(@val != ''){
        runas('~console',"/disguiseplayer " . @plr . ' player ' . @plr . ' setskin {"id":"87fb3c6c5ff64bf6b326992c6137ea12","name":"tektronic","properties":[{"signature":"'.@sig.'","name":"textures","value":"'.@val.'"}]}')
    } else {
        runas('~console','/disguiseplayer '.@plr.' '.@sig.' '.@val)
    }
    
)

proc('_changeSkinMindControl', @plr, @sig, @val, @vic, 

    if(@val != ''){
        runas('~console',"/disguiseplayer " . @plr . " player " . @vic . ' setskin {"id":"87fb3c6c5ff64bf6b326992c6137ea12","name":"tektronic","properties":[{"signature":"'.@sig.'","name":"textures","value":"'.@val.'"}]}')
    } else {
        runas('~console','/disguiseplayer '.@plr.' '.@sig.' '.@val)
    }
    
)

