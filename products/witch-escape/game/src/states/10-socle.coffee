class Phacker.Game.Socle

    constructor: (@gm) ->
        @_fle_ = 'Socle'

        @pm = @gm.parameters = {}

        # more easy to define here some sprte's parameters
        @pm.spt = { vx0: 120}

        @pm.bg = # background
            x0: 0
            y0: 48
            w: if @gm.gameOptions.fullscreen  then 375 else 768
            h: if @gm.gameOptions.fullscreen  then 559 else 500

        @pm.cld = {x0: -100, y0: @pm.bg.y0, vx: 100 }

        @pm.deco = {  x0: 0,  h:  240}
        @pm.deco.y1_0 = @pm.bg.h - @pm.deco.h - 50 #for deco1
        @pm.deco.y2_0 = @pm.bg.h - @pm.deco.h   #for deco2

        @pm.sea =
            x0:  0
            h1:  64 # seas have'nt same height
            h2:  59
            h3:  52
        @pm.sea.y3_0 = @pm.bg.h - @pm.sea.h1 #sea3
        @pm.sea.y2_0 = @pm.bg.h - @pm.sea.h2  #sea2
        @pm.sea.y1_0 = @pm.bg.h - @pm.sea.h3 #sea1

        #platform
        @pm.pfm =
            x0: 0 #if @gm.gameOptions.fullscreen then -60 else -100
            w:  218
            h:  220
        @pm.pfm.y0 = @pm.bg.h - @pm.pfm.h

        @draw_bg()

    #.----------.----------
    # build socle
    #.----------.----------

    draw_bg: ->
        @bg = @gm.add.sprite @pm.bg.x0, @pm.bg.y0, 'bg_gameplay' # 768x500
        @bg.fixedToCamera = true

        @cld1 = @gm.add.sprite @pm.cld.x0, @pm.cld.y0, 'cloud' # 768x70
        @gm.physics.arcade.enable @cld1,Phaser.Physics.ARCADE
        @cld1.body.velocity.x = @pm.cld.vx #+ @pm.spt.vx0
        @cld2 = @gm.add.sprite  @pm.cld.x0 + @pm.bg.w, @pm.cld.y0, 'cloud' # 768x70
        @gm.physics.arcade.enable @cld2,Phaser.Physics.ARCADE
        @cld2.body.velocity.x = @pm.cld.vx #+ @pm.spt.vx0

        @deco2 = @gm.add.sprite @pm.deco.x0, @pm.deco.y1_0, 'deco_2' # 768x240
        @deco2.fixedToCamera = true
        @deco1 = @gm.add.sprite @pm.deco.x0, @pm.deco.y2_0, 'deco_1'
        @deco1.fixedToCamera = true

        @sea3 = @gm.add.sprite @pm.sea.x0, @pm.sea.y3_0, 'sea3' # 768x64
        @sea3.fixedToCamera = true
        @sea2   = @gm.add.sprite @pm.sea.x0, @pm.sea.y2_0, 'sea2' # 768x59
        @sea2.fixedToCamera = true
        @sea1   = @gm.add.sprite @pm.sea.x0, @pm.sea.y1_0, 'sea1' # 768x62
        @sea1.fixedToCamera = true

        @pfm   = @gm.add.sprite @pm.pfm.x0, @pm.pfm.y0, 'platform' # 218x220
        @gm.physics.arcade.enable @pfm,Phaser.Physics.ARCADE
        @pfm.body.immovable = true


    #.----------.----------
    # move background clouds
    #.----------.----------
    move_clouds:(spt) ->

        if @cld1.x + 70 + @pm.bg.w < spt.x
            @cld1.x = @cld2.x + @pm.bg.w
        else if @cld2.x + @pm.bg.w + 70 < spt.x
            @cld2.x = @cld1.x + @pm.bg.w