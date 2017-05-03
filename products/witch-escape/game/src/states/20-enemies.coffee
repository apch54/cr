###  written by apch on 2017-04-27enemy  ###
#         ___
#        | __|_ _  ___ _ __ _  _
#        | _|| ' \/ -_) '  \ || |
#        |___|_||_\___|_|_|_\_, |
#                           |__/
class Phacker.Game.Enemies

    constructor: (@gm) ->
        @_fle_ = 'Enemies'

        @pm = @gm.parameters.emy =
            x0 : @gm.parameters.pfm.w + 80
            y0: @gm.parameters.pfm.y0
            w: 50
            h: 24
            names:['enemy2','enemy1',]
            nb: if @gm.gameOptions.fullscreen  then 4 else 7 # number of enemies in the group
            dx: @gm.gameOptions.dx
            ddx:@gm.gameOptions.dx_step_per_score # dx variation, depending on @gm.ge.score
        #position of enemy (sweeper)
        @pm.y =  [@pm.y0 + 25, @pm.y0, @pm.y0 - 25, @pm.y0 - 50, @pm.y0 - 75 ]

        @emy = @gm.add.physicsGroup()
        @emy.enableBody = true

        @init()# init gpoup : emy

    #.----------.----------
    # initialisation of enemies : make nb emy
    #.----------.----------
    init:() ->

        dx = @fdx() # compute intervall between 2 sweepers: enemies @pm.w + @pm.dx + Math.floor(@gm.ge.score / 60) * @pm.dx * @pm.ddx

        #first sweeper (emy)
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

    #----------.----------
    # create_destroy enemies
    #----------.----------
    create_destroy: () ->

        em0 = @emy.getAt(0)

        # destroy enemy  & handle ghost
        if  @gm.camera.x > em0.x + @pm.w
            em0.destroy()

            xy = @rules @emy.getAt(@emy.length - 1).x # x of last emy
            @make_1_emy(xy.x, xy.y)

    #.----------.----------
    # rules of game : determine x, y between 2 sweepers (emy)
    #.----------.----------
    rules: (x) ->

        # space between 2 sweepers (@emy) depends only on score : 60, 120, 180
        xx = x + @fdx() # @pm.w + @pm.dx + Math.floor(@gm.ge.score / 60) * @pm.dx * @pm.ddx
        if @gm.ge.score < 60
            yy = @pm.y[@gm.rnd.integerInRange(1,2)]
        else if @gm.ge.score < 120
            yy = @pm.y[@gm.rnd.integerInRange(1,3)]
        else
            yy = @pm.y[@gm.rnd.integerInRange(0,3)]

        return {x: xx,y: yy}

    #----------.----------
    # set invisible all sweepers(@emy) behind spt.x
    # when  sprite loose
    #----------.----------
    destroy_behind:(spt)->

        for i in  [1..@emy.length]
            e = @emy.getAt(i - 1 )
            #console.log @_fle_,': ',e.x , @gm.parameters.spt.w , spt.x
            if e.x - @gm.parameters.spt.w - 30 < spt.x then e.y = -100
            else return

    #.----------.----------
    # some tools
    #.----------.----------
    len:-> @emy.children.length # len enemy        # compute number of enemies
    last:-> @emy.getAt( @emy.children.length - 1 ) # compute last enemies

    # compute intervall between 2 sweepers: @emy
    fdx:->
        #console.log @_fle_,': ',@pm.w + @pm.dx + Math.floor(@gm.ge.score / 60) * @pm.dx * @pm.ddx
        @pm.w + @pm.dx + Math.floor(@gm.ge.score / 60) * @pm.dx * @pm.ddx

    bind:(sptO,ghtO )->
        @sptO = sptO
        @ghtO = ghtO

