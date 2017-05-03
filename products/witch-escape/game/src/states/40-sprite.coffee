###  written by apch on 2017-04-25  ###
#                 _ _
#     ____ __ _ _(_) |_ ___
#    (_-< '_ \ '_| |  _/ -_)
#    /__/ .__/_| |_|\__\___|
#       |_|

class Phacker.Game.Sprite

    constructor: (@gm) ->
        @_fle_ = 'Sprite'

        # IMPORTANT : parameters @pm.vx0 is defined in socle

        @pm = @gm.parameters.spt
        @pm.x0  = 10                  # initial x location
        @pm.y0  = @gm.parameters.pfm.y0 - 50
        @pm.w   = 35                  # width of the sprite
        @pm.h   = 45                  # height of the sprite
        @pm.g   = 350                 # gravity
        @pm.vy  = {low: -500,   top: 150}    # velocity on collide enemy
        @pm.dvx0= @pm.vx0 * 1         # velocity variation on tap
        @pm.top = if @gm.gameOptions.fullscreen then 140 else 90               # top boundary
        @pm.mes_emy = "not yet"  # message returned when sprite collide
        #@pm.lost = false

        #define sprite

        @spt = @gm.add.sprite @pm.x0, @pm.y0  , 'character_sprite'  # 95 x 102
        @gm.physics.arcade.enable @spt,Phaser.Physics.ARCADE
        @spt.body.setSize(25, 45, 5, 0) # w, h, offset x, offset y
        @spt.body.bounce.y = 1
        @spt.body.gravity.y  = @pm.g
        @spt.body.velocity.x = @pm.vx0

        @anim_spt = @spt.animations.add 'anim', [0, 1, 2, 3], 15, true
        @spt.animations.play 'anim'

    #.----------.----------
    # collide sprite with enemy
    # and test sprite on platform
    #.----------.----------
    collide_emy: (emy) -> # collide with enemy

        #at the begining of the game
        # is sprite on platform
        if @gm.parameters.pfm.w - 40 < @spt.x < @gm.parameters.pfm.w - 35
            @spt.body.velocity.y = @pm.vy.low
            #console.log @_fle_,': ',@gm.parameters.pfm.w - 20,@spt.x ,@gm.parameters.pfm.w - 15

        #bounce on top or toolow ?
        if @spt.y < @pm.top then @spt.body.velocity.y = @pm.vy.top
        else if @spt.y > @gm.parameters.sea.y3_0 + 20 and not @gm.parameters.losting #@pm.lost
            @gm.parameters.losting = on #@pm.lost = true
            @make_twn_collide()
            @effO.play @spt
            return 'bad'

        #test collision sprite and enemy
        if @gm.physics.arcade.collide(
            @spt, emy
            -> return true
            (spt, emy)-> @when_collide_emy(spt, emy)
            @
        ) then return @pm.mes_emy # set message

        return 'no'

    #.----------.----------
    when_collide_emy:(spt, emy) ->

        spt.body.velocity.y = -@pm.vy.low # set velocity BEFORE bouncing
        if @gm.math.fuzzyEqual(spt.y +  @pm.h, emy.y, 6) # max 6 pxl on top enemy
            @pm.mes_emy = 'win'    # set message
        else if not @gm.parameters.losting #@pm.lost
            @gm.parameters.losting = on #@pm.lost = on
            emy.y = -100
            @make_twn_collide()
            @effO.play spt
            @pm.mes_emy = 'bad'  # set message
        # console.log @_fle_,': ', spt.y + @pm.h,emy.y,spt.body.velocity.x
        return true  # return it has collided

    #.----------.----------
    # tween when ghost collide sprite
    #.----------.----------
    make_twn_collide: () ->
        @stop()
        twn_collide = @gm.add.tween  @spt
        twn_collide.to(
            { alpha : 0 , angle : 360, y:  600}
            1000, Phaser.Easing.Linear.None
        )

        twn_collide.start()

    #.----------.----------
    # some tools
    #.----------.----------
    # set prite velocity on x & y axises to 0
    stop:  ->
        @spt.body.velocity.x = 0
        @spt.body.velocity.y = 0
        @spt.body.gravity.y = 0

    bind:(effO) ->
        @effO = effO # bind with effect object


