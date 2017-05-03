###  written by apch on 2017-04-26  ###
    
#       ... --- ...
#      |          ,----------------------------.
#      |.===.     | Hello every one ; fine ?   |
#      {}o o{}    _)---------------------------'
#   ooO--(_)--Ooo-

class Phacker.Game.Socle

    constructor: (@gm) ->
        @_fle_ = 'Socle'

        @pm = @gm.parameters = {}
        @pm.losting = false

        # more easy to define here some sprte's parameters
        @pm.spt =
            vx0: @gm.gameOptions.vx0
            dvx0_per_level: @gm.gameOptions.dvx0_per_level
        @pm.spt.vx0 = @pm.spt.vx0 * Math.pow(@pm.spt.dvx0_per_level,@gm.ge.level)
        #console.log @_fle_,': ',@pm.spt.vx0, @pm.spt.dvx0_per_level

        @pm.bg = # background
            x0: 0 # initial location
            y0: 48
            w: if @gm.gameOptions.fullscreen  then 375 else 768
            h: if @gm.gameOptions.fullscreen  then 559 else 500

        @pm.cld =
            x0: -220 # initial location
            y0: @pm.bg.y0
            vx: 30
            w:  768

        @pm.deco = {  x0: 0,  h:  240}
        @pm.deco.y1_0 = @pm.bg.h - @pm.deco.h - 50 #for deco1
        @pm.deco.y2_0 = @pm.bg.h - @pm.deco.h   #for deco2

        @pm.sea =
            x0:  0 # initial location
            h1:  52 # seas have'nt same height
            h2:  59
            h3:  64
        @pm.sea.y3_0 = @pm.bg.h - @pm.sea.h3  - 10  #sea3
        @pm.sea.y2_0 = @pm.bg.h - @pm.sea.h2  - 5 #sea2
        @pm.sea.y1_0 = @pm.bg.h - @pm.sea.h1  #sea1

        #platform
        @pm.pfm =
            x0: 0
            w:  218
            h:  220
        @pm.pfm.y0 = @pm.bg.h - @pm.pfm.h

        @pm.boat =
            w: 115
            h: 80
        @pm.boat.y0 = @pm.sea.y3_0 - @pm.boat.h + 35
        @pm.boat.x0l = @pm.bg.w * .1  # left boat
        @pm.boat.x0r = @pm.bg.w * .6   # leftright

        @draw_bg()

    #.----------.----------
    # build socle
    #.----------.----------

    draw_bg: ->

        #.----------# background
        @bg = @gm.add.sprite @pm.bg.x0, @pm.bg.y0, 'bg_gameplay' # 768x500
        @bg.fixedToCamera = true

        #.----------# cloud
        @cld1 = @gm.add.sprite @pm.cld.x0, @pm.cld.y0, 'cloud' # 768x70
        @gm.physics.arcade.enable @cld1,Phaser.Physics.ARCADE
        @cld1.body.velocity.x = -@pm.cld.vx #+ @pm.spt.vx0
        @cld2 = @gm.add.sprite  @pm.cld.x0 + @pm.cld.w, @pm.cld.y0, 'cloud' # 768x70
        @gm.physics.arcade.enable @cld2,Phaser.Physics.ARCADE
        @cld2.body.velocity.x = -@pm.cld.vx #+ @pm.spt.vx0

        #.----------# two decos
        @deco2 = @gm.add.sprite @pm.deco.x0, @pm.deco.y1_0, 'deco_2' # 768x240
        @deco2.fixedToCamera = true
        @deco1 = @gm.add.sprite @pm.deco.x0, @pm.deco.y2_0, 'deco_1'
        @deco1.fixedToCamera = true

        #.----------# platform at the begining of the game
        @pfm   = @gm.add.sprite @pm.pfm.x0, @pm.pfm.y0, 'platform' # 218x220
        @gm.physics.arcade.enable @pfm,Phaser.Physics.ARCADE
        @pfm.body.immovable = true
        #@pfm.fixedToCamera = true

        #.----------# two boats
        @boatl = @gm.add.sprite @pm.boat.x0l , @pm.boat.y0, 'boat1' # 115x80
        @boatl_twn = @gm.add.tween (@boatl)
        @boatl_twn.to( {  y:[@pm.boat.y0 - 9, @pm.boat.y0], angle:[7,0]  }, 1600, Phaser.Easing.Linear.None, true, 0, -1 )

        @boatr = @gm.add.sprite @pm.boat.x0r , @pm.boat.y0, 'boat2' # 115x80
        @boatr_twn = @gm.add.tween (@boatr)
        @boatr_twn.to( {  y:[@pm.boat.y0 - 5, @pm.boat.y0] }, 1000, Phaser.Easing.Linear.None, true, 0, -1 )

        #.----------#three seas
        @sea3 = @gm.add.sprite @pm.sea.x0, @pm.sea.y3_0, 'sea3' # 768x64
        @sea3.fixedToCamera = true
        @sea2   = @gm.add.sprite @pm.sea.x0, @pm.sea.y2_0, 'sea2' # 768x59
        @sea2.fixedToCamera = true

        # only sea1 is moving
        @sea1   = @gm.add.sprite @pm.sea.x0, @pm.sea.y1_0, 'sea1' # 768x62
        @gm.physics.arcade.enable @sea1,Phaser.Physics.ARCADE
        @sea1_twn = @gm.add.tween  @sea1
        @sea1_twn.to( {  y:[@pm.sea.y1_0 - 7, @pm.sea.y1_0 ] }, 1200, Phaser.Easing.Linear.None, true, 0, -1 )

        #@sea1.fixedToCamera = true

    #.----------.----------
    # move background clouds and boats
    #.----------.----------
    move_clouds_boats:(spt) -># sp
        # begining of the game sprite's on platfom
        if spt.x > @pm.pfm.w
            @cld1.body.velocity.x = @pm.spt.vx0 - @pm.cld.vx
            @cld2.body.velocity.x = @pm.spt.vx0 - @pm.cld.vx

        # sprite'snt on platfom anymore
        if @cld1.x + @pm.cld.w + 70 < spt.x
            @cld1.x = @cld2.x + @pm.cld.w
        else if @cld2.x + @pm.cld.w + 70 < spt.x
            @cld2.x = @cld1.x + @pm.cld.w

        # move boats
        @boatl.x = @gm.camera.x + @pm.boat.x0l
        @boatr.x = @gm.camera.x + @pm.boat.x0r

        @sea1.x = @gm.camera.x

