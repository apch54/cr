###  written by fc on 2017-04-25  ###
#    ___                _   _
#   / __|  _ __   _ _  (_) | |_   ___
#   \__ \ | '_ \ | '_| | | |  _| / -_)
#   |___/ | .__/ |_|   |_|  \__| \___|
#         |_|
class Phacker.Game.Sprite

    constructor: (@gm) ->
        @_fle_ = 'Sprite'

        # IMPORTANT : parameters @pm.vx0 is defined in socle
        @pm = @gm.parameters.spt
        @pm.x0  = 10
        @pm.y0  = @gm.parameters.pfm.y0 - 50
        @pm.w   = 98                  # width of the sprite
        @pm.h   = 105                 # height of the sprite
        @pm.g   = 350                 # gravity
        @pm.vy  = {low: -500,   top: 100}    # velocity on collide enemy
        @pm.vy
        @pm.dvx0= @pm.vx0 / 3        # velocity variation on tap
        @pm.top = 100                # top boundary
        @pm.message_emy = "not yet"  # message returned when sprite collide

        #define pm
        @spt = @gm.add.sprite @pm.x0, @pm.y0  , 'character_sprite'  # 95 x 102
        @gm.physics.arcade.enable @spt,Phaser.Physics.ARCADE
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

        # is sprite on platform
        if @gm.parameters.pfm.w - 20 < @spt.x < @gm.parameters.pfm.w
            @spt.body.velocity.y = @pm.vy.low

        #bounce on top
        if @spt.y < @pm.top then @spt.body.velocity.y = @pm.vy.top

        if @gm.physics.arcade.collide(
            @spt, emy
            -> return true
            (spt, emy)-> @when_collide_with_emy(spt, emy)
            @
        ) then return @pm.message
        return 'nothing'

    #.----------.----------

    when_collide_with_emy:(spt, emy) ->
        @pm.message = 'collided'
        return true


