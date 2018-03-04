set_cron('* * * * *',closure(

    @plrs = players_in_radius(array('x':'0','y':'101','z':'0','world':'mainmenu'),3)

    //console('DOING CRON!')
    foreach(@plr in @plrs){
        //console(@plr)
        set_peffect(@plr,14,1,64,true,false)
    }

))