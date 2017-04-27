class Phacker.Game.Enemies

    constructor: (@gm) ->
        @_fle_ = 'Enemies'

        @pm = @gm.parameters.emy =
            x0 : @gm.parameters.pfm.w + 100
            y0: @gm.parameters.pfm.y0
            w: 50
            h: 24
            names:['enemy2','enemy1',]

        @emy = @gm.add.physicsGroup()

        @make_1_emy(@pm.x0,@pm.y0)


    #.----------.----------
    # make only one enemy
    #.----------.----------
    make_1_emy: (x,y) ->
        e = @emy.create x, y, @pm.names[@gm.rnd.integerInRange(0,1)]
        e.body.immovable = true
        console.log @_fle_,': ',@emy.getAt(0)

    #.----------.----------
    # binder with sprite
    #.----------.----------
    bind:(spt)-> @spt=spt