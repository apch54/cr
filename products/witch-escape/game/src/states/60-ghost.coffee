###  written by fc on 2017-04-30  ###

class Phacker.Game.Ghost

    constructor: (@gm, @sptO, @emyO) ->
        @_fle_ = 'Ghost'

        @pm = @gm.parameters.ght = #ght stands for ghost
            w: 32
            h: 60
            vx: -30
            x0: if @gm.gameOptions.fullscreen then  2 * @gm.parameters.bg.w else @gm.parameters.bg.w
            y:@gm.parameters.emy.y
        #console.log @_fle_,': ','in ghost', @sptO
        @make_ght()

    make_ght:->
        @ght = @gm.add.sprite @pm.x0, @pm.y[@gm.rnd.integerInRange(0,@pm.y.length - 1)] , 'floater'  #32 x 60
        @gm.physics.arcade.enable @ght,Phaser.Physics.ARCADE
        @ght.body.setSize(19, 60, 5, 0) # w, h, offset x, offset y
        @ght.body.velocity.x = @pm.vx