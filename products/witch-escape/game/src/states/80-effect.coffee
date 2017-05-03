class Phacker.Game.Effects

    constructor:(@gm) ->
        @_fle_      ='Effect'
        @effects = ['effect1','effect3','effect2']

    #.----------.----------
    # play animation & stop when collide with platform
    #.----------.----------
    play:(obj) ->

        @eff. destroy() if @eff?
        n =  if @gm.gameOptions.color_effect then 1 else @gm.rnd.integerInRange(0, 1) # choose animation

        @eff= @gm.add.sprite 50, 100, @effects[n] ,2 #86x88 & create effect
        @eff.tint = Math.random() * 0xffffff if @gm.gameOptions.color_effect
        @eff.anchor.setTo(0.5, 0.5) # anchor in the middle of bottom

        anim = @eff.animations.add  'explode', [2, 1, 0, 1, 2, 1, 0, 1, 2 ], 8, false
        anim.onComplete.add(
            ()-> @eff.destroy()
            @
        )
        @eff.x = obj.x   #set effect location
        @eff.y = obj.y
        @eff.animations.play 'explode'

    #.----------.----------
    # effect  with no color effect
    # .----------.----------

    play_color_off:(x,y) ->
        n = @gm.rnd.integerInRange 1, 1 # choose animation

        @eff= @gm.add.sprite 50, 100, @effects[n] ,2 #86x88 & create effect
        @eff.anchor.setTo(0.5, 0.5) # anchor in the middle of bottom
        anim = @eff.animations.add  'explode', [2, 1, 0, 1], 8, false
        anim.onComplete.add(
            ()-> @eff.destroy()
            @
        )
        @eff.x =  x   #set effect location
        @eff.y =  y

        @eff.animations.play 'explode'

    #.----------.----------
    # destroy effect
    # .----------.----------
    stop: -> @eff.destroy()



