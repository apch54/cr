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
        @pm.x0 = 10
        @pm.y0 = @gm.parameters.pfm.y0 - 50
        @pm.w = 98                  # width of the sprite
        @pm.h = 105                 # height of the sprite
        @pm.g = 300                 # gravity
        @pm.vyLow = -400            # velocity on collide ennemy
        @pm.dvx0 = @pm.vx0 / 3       # velocity variation on tap

        #define pm
        @spt = @gm.add.sprite @pm.x0, @pm.y0  , 'character_sprite'  # 95 x 102
        @gm.physics.arcade.enable @spt,Phaser.Physics.ARCADE
        #@spt.body.bounce.y = 0
        @spt.body.gravity.y  = @pm.g
        @spt.body.velocity.x = @pm.vx0

        @anim_spt = @spt.animations.add 'anim', [0, 1, 2, 3], 15, true
        @spt.animations.play 'anim'

    #.----------.----------
    # collide sprite with ennemy
    # and test sprite on platform
    #.----------.----------
    collide_eny: (eny) -> # collide with enemy

        # is sprite on platform
        if @gm.parameters.pfm.w - 20 < @spt.x < @gm.parameters.pfm.w
            @spt.body.velocity.y = @pm.vyLow