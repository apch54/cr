class Phacker.Game.Enemies

    constructor: (@gm) ->
        @_fle_ = 'Enemies'

        @pm = @gm.parameters.emy =
            x0 : @gm.parameters.pfm.w + 100
            y0: @gm.parameters.pfm.y0
            w: 50
            h: 24
            names:['enemy2','enemy1',]
            nb: 7 # number of enrmies in the group

        @emy = @gm.add.physicsGroup()
        @emy.enableBody = true

        @init()# init gpoup : emy

    #.----------.----------
    # initialisation of enemies : make nb emy
    #.----------.----------
    init:() ->
        xx = @pm.x0
        dx = 20 + @pm.w
        for i in [1..@pm.nb]
            @make_1_emy(xx, @pm.y0)
            console.log @_fle_,': ',@emy.children.length
            xx =  @emy.getAt(@emy.children.length - 1).x + dx

    #.----------.----------
    # make only one enemy
    #.----------.----------
    make_1_emy: (x,y) ->
        e = @emy.create x, y, @pm.names[@gm.rnd.integerInRange(0,1)]
        e.body.immovable = true
        e.touched = false
        #console.log @_fle_,': ',@emy.getAt(0)

    #.----------.----------
    # binder with sprite
    #.----------.----------
    bind:(spt)-> @spt=spt
