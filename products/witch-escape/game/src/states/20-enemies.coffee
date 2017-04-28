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
            dx: 70
            ddx: .20 # dx variation, depending on @gm.ge.score
        #position of enemy (sweeper)
        @pm.y =  [@pm.y0 + 40 ,@pm.y0, @pm.y0 - 40,@pm.y0 - 80]


        @emy = @gm.add.physicsGroup()
        @emy.enableBody = true

        @init()# init gpoup : emy

    #.----------.----------
    # initialisation of enemies : make nb emy
    #.----------.----------
    init:() ->
        dx = @pm.w + @pm.dx + Math.floor(@gm.ge.score / 60) * @pm.dx * @pm.ddx

        #first sweeper
        @make_1_emy(@pm.x0, @pm.y0)
        xx =  @pm.x0 + dx

        for i in [2..@pm.nb]
            yy = @pm.y[@gm.rnd.integerInRange(1,2)]
            @make_1_emy(xx, yy)
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
