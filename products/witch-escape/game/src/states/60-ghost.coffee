###  written by fc on 2017-04-30  ###

class Phacker.Game.Ghost

    constructor: (@gm) ->
        @_fle_ = 'Ghost'

        @pm = @gm.parameters.ght = #ght stands for ghost
            w: 32
            h: 60
            vx: -30
            x0: if @gm.gameOptions.fullscreen then  2 * @gm.parameters.bg.w else @gm.parameters.bg.w
            y0: @gm.parameters.pfm.y0
        @pm.y =   [@pm.y0,  @pm.y0 - 50,@pm.y0 - 100, @pm.y0 - 150]
        #dx whenthe floater (ghost, ght) repear
        @pm.dx =  [@pm.x0 * 1.2 ,@pm.x0 * 1.6, @pm.x0 * 2]

        #console.log @_fle_,': ','in ghost', @sptO
        @make_ght()

    make_ght:->
        @ght = @gm.add.sprite @pm.x0, @pm.y[@gm.rnd.integerInRange(0,@pm.y.length - 1)] , 'floater'  #32 x 60
        @gm.physics.arcade.enable @ght,Phaser.Physics.ARCADE
        @ght.body.setSize(19, 60, 5, 0) # w, h, offset x, offset y
        @ght.body.velocity.x = @pm.vx

    #.----------.----------
    # check ghost location for setting visible
    #.----------.----------
    check_x:->
        if @gm.camera.x + 50 > @ght.x + @pm.w
            @ght.x += @pm.dx[@gm.rnd.integerInRange(0, @pm.dx.length - 1)]
            @ght.y = @pm.y[@gm.rnd.integerInRange(0, @pm.y.length - 1)]


    #.----------.----------
    # check ghost (@ght) overlaping sprite (spt)
    #.----------.----------
    check_overlap: (spt) ->
        g_bnd = @ght.getBounds()  # ghost
        s_bnd =  spt.getBounds()   #sprite bounds
        if Phaser.Rectangle.intersects(s_bnd, g_bnd)
            return 'overlaping'
        else return ' no overlaping'