class Phacker.Game.Enemies

    constructor: (@gm) ->
        @_fle_ = 'Enemies'

        @pm = @gm.parameters.emy =
            x0 : @gm.parameters.pfm.w + 100
            y0: @gm.parameters.pfm.y0
            w: 50
            h: 24
            names:['enemy2','enemy1',]
            nb: 5 # number of enrmies in the group

        @emy = @gm.add.physicsGroup()
        @emy.enableBody = true

        @init()# init gpoup : emy

    #.----------.----------
    # initialisation of enemies : make nb emy
    #.----------.----------
    init:() ->
        xx = @pm.x0
        dx = 40 + @pm.w
        for i in [1..@pm.nb]
            @make_1_emy(xx, @pm.y0)
            xx =  @last().x + dx


    #.----------.----------
    # make only one enemy
    #.----------.----------
    make_1_emy: (x,y) ->
        e = @emy.create x, y, @pm.names[@gm.rnd.integerInRange(0,1)]
        e.body.immovable = true
        anim = e.animations.add 'anim', [0, 1, 2, 3], 5, true
        e.animations.play 'anim'
        e.touched = false

    #.----------.----------
    # some tools
    #.----------.----------
    len:-> @emy.children.length # len enemy
    last:-> @emy.getAt( @emy.children.length - 1 )
    bind:(spt)-> @spt = spt
