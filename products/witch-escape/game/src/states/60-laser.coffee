###  written by apch on 2017-04-30 : Ghost object  ###
#    _
#   | |__ _ ______ _ _
#   | / _` |_ / -_) '_|
#   |_\__,_/__\___|_|

class Phacker.Game.Laser

    constructor: (@gm,@wchO) -> # wth stands for "witch object" not to confuse with that spritr
        @_fle_ = 'Laser'

        @pm = @gm.parameters.lsr = #lsr stands for laser
            w: 20
            h: 315
            dv0: .7 # relative velocity en percent between sprite & laser

            # time of laser apparition after diappretion  in seconds;
            # warning : not true at the game begining (<> 3 sec)
            dt: 8

        @pm.vx0 = @gm.parameters.spt.vx0 * ( 1 + @pm.dv0) # laser velocity on x axis
        @pm.x0  = @gm.parameters.spt.vx0 * @pm.dv0 * @pm.dt # dx between laser and sprte depend of time
        @pm.y0  = @gm.parameters.spt.top + @gm.gameOptions.laser_top

        @pm.scl = ( @gm.parameters.bg.h - @pm.y0 ) / @pm.h # laser scale on y axis
        console.log @_fle_,': ',@pm.scl,@pm.h,@gm.parameters.bg.h - @pm.y0


            #.----------.----------
        # draw laser sprite
        #.----------.----------
        # beware the "3 seconds" below : at the begening of game only
        @spt = @gm.add.sprite  -@gm.parameters.spt.vx0 * @pm.dv0 * (@pm.dt + 3) , @pm.y0, 'laser'  #10 x 315
        @spt.scale.setTo(1, @pm.scl)
        @gm.physics.arcade.enable @spt,Phaser.Physics.ARCADE


        @anim_spt = @spt.animations.add 'anim', [0, 1], 25, true
        @spt.animations.play 'anim'

        @spt.body.velocity.x = @pm.vx0
        #@spt.had_collided = false

    #.----------.----------
    # 1/ check x laser and set it behind sprite
    # 2/ check collision
    #.----------.----------

    check_x : (witch) ->
        if @spt.x > @gm.camera.x + @gm.parameters.bg.w
            @spt.x = @gm.camera.x - @pm.x0

        # check collision, stop witch sprite and return 'bad'
        if Phaser.Rectangle.intersects(@spt.getBounds(), witch.getBounds()) and not @gm.parameters.losting
            @gm.parameters.losting = true
            @effO.play witch
            @wchO.make_twn_collide() # stop main sprite : witch

            return 'loose'

    #.----------.----------
    # some tools
    #.----------.----------
    bind:(effO) -> @effO = effO
