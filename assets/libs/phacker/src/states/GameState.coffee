pointToLevel = (ptl1, ptnl, x) ->
    if x == 1
        return ptl1

    return pointToLevel(ptl1, ptnl, x-1) + ( pointToLevel(ptl1, ptnl, x-1) * ptnl );

class Phacker.GameState extends Phacker.BaseState
    statusBarTextColor: 'white'
    timerColor: 0x666666
    timerBgColor: 0xffffff

    create: ->

        hackBottomFullScreen?('gameplay');

        super()

        @loopSound = @game.add.audio 'loopSound'
        @loopSound.play('', 0, 1, true)

        @game.input.touch.preventDefault = true

        if @game.gameOptions.pub_ads_game and @game.gameOptions.afg_start
            @game.paused = true

        if !@game.gameOptions.durationByLevel?
            @game.gameOptions.durationByLevel = true

        if !@game.ge.remainingTime?
            @game.ge.remainingTime = @game.gameOptions.duration

        @game.ge.generalTimer = @game.time.create()
        @game.ge.generalTimer.add @game.ge.remainingTime * 1000, ( ->
            if @game.ge.level >= @game.gameOptions.winningLevel and @game.gameOptions.timingTemps == true and @game.ge.generalTimer.duration == 0 and @game.ge.nowinagain == true
                @game.ge.nowinagain = false
                @game.state.start 'win'
                @cutLoop()
            else
                if @game.ge.nb_replay%@game.gameOptions.nativeIntersticielPonderation == 0
                    console.log "native"

                @endGame()
        ).bind @

        @game.ge.generalTimer.start()

        @statusBar = @game.add.image(0, 0, 'status_bar')
        @statusBar.fixedToCamera = true

        # else
        @timerBase = @game.add.graphics(0, 0)
        @timerBase.beginFill @timerBgColor, 1
        @timerBase.drawRect 0, 0, @statusBar.width*0.25, 10
        @timerBase.graphicsData[0].shape.x = @statusBar.width*0.5 - @timerBase.graphicsData[0].shape.width*0.5
        @timerBase.graphicsData[0].shape.y = @statusBar.height*0.5 - @timerBase.graphicsData[0].shape.height*0.5
        @timerBase.fixedToCamera = true

        @remainingTime = @game.add.graphics(0, 0)
        @remainingTime.beginFill @timerColor, 1
        @remainingTime = @remainingTime.drawRect(0, 0, 0, @timerBase.graphicsData[0].shape.height)
        @remainingTime.graphicsData[0].shape.x = @timerBase.graphicsData[0].shape.x
        @remainingTime.graphicsData[0].shape.y = @timerBase.graphicsData[0].shape.y
        @remainingTime.fixedToCamera = true

        @chronos = @game.add.image(0, 0, 'chronos')
        @chronos.x = @timerBase.graphicsData[0].shape.x - @chronos.width - 5
        @chronos.y = @statusBar.height*0.5 - @chronos.height*0.5
        @chronos.fixedToCamera = true

        @scoreIcon = @game.add.image(0, 0, 'scoreicon')
        @scoreIcon.x = @statusBar.x + 20
        @scoreIcon.y = @statusBar.height*0.5 - @scoreIcon.height*0.5
        @scoreIcon.fixedToCamera = true

        @scoreText = @game.add.text(0, 0, @game.ge.score,
            font: 'bold 18pt Lobster'
            fill: @statusBarTextColor)
        @scoreText.x = @scoreIcon.x + @scoreIcon.width + 10
        @scoreText.y = @statusBar.height*0.5 - @scoreText.height*0.5
        @scoreText.fixedToCamera = true


        @levelText = @game.add.text(0, 0, @game.ge.level,
            font: 'bold 18pt Lobster'
            fill: @statusBarTextColor)
        @levelText.x = @statusBar.x + @statusBar.width - @levelText.width - 20
        @levelText.y = @statusBar.height*0.5 - @levelText.height*0.5
        @levelText.fixedToCamera = true

        @levelIcon = @game.add.image(0, 0, 'statusbarpump')
        @levelIcon.x = @levelText.x - @levelIcon.width - 10
        @levelIcon.y = @statusBar.height*0.5 - @levelIcon.height*0.5
        @levelIcon.fixedToCamera = true

        if @game.gameOptions.fullscreen
            @timerBase.graphicsData[0].shape.y = 10
            @remainingTime.graphicsData[0].shape.y = 10

        @deadlifeInit()
        @lifeInit()

    nextLevel: ->
        @game.ge.level++

        @game.ge.remainingTime = Math.round @game.ge.generalTimer.duration/1000
              
        if @game.gameOptions.winningLevel > 1 and @game.gameOptions.winningLevel != @game.ge.level
            @game.state.start 'nextLevel'
            @cutLoop()
        

    update: ->
        @remainingTime.graphicsData[0].shape.width = @game.ge.generalTimer.duration * @statusBar.width / 4 / (@game.gameOptions.duration * 1000)

        if @game.ge.level >= @game.gameOptions.winningLevel and @game.gameOptions.timingTemps == false and @game.ge.nowinagain == true
            @game.ge.nowinagain = false
            @game.state.start 'win'
            @cutLoop()

        if @game.ge.level == 0

            if @game.ge.score >= @game.gameOptions.pointToLevel1
                @nextLevel()
        else
            if @game.ge.score >= pointToLevel(@game.gameOptions.pointToLevel1, @game.gameOptions.percentToNextLevel, @game.ge.level+1)
                @nextLevel()
    win: ->
        winSound = @game.add.audio 'winSound'
        winSound.play()

        @game.ge.score += @game.gameOptions.pointEarned
        @scoreText.setText(@game.ge.score)
        @scoreText.x = @scoreIcon.x + @scoreIcon.width + 10
        @scoreText.y = @statusBar.height*0.5 - @scoreText.height*0.5
    winBonus: ->
        bonusSound = @game.add.audio 'bonusSound'
        bonusSound.play()
        
        @game.ge.score += @game.gameOptions.pointBonus
        @scoreText.setText(@game.ge.score)
        @scoreText.x = @scoreIcon.x + @scoreIcon.width + 10
        @scoreText.y = @statusBar.height*0.5 - @scoreText.height*0.5
    lost: ->
        lostSound = @game.add.audio 'lostSound'
        lostSound.play()

        @game.ge.score = Math.max(0, @game.ge.score - @game.gameOptions.pointLost)
        @scoreText.setText(@game.ge.score)
        @scoreText.x = @scoreIcon.x + @scoreIcon.width + 10
        @scoreText.y = @statusBar.height*0.5 - @scoreText.height*0.5
    lostLife: ->
        lastElement = @game.ge.heart[@game.ge.heart.length - 1]
        lastElement.destroy()
        @game.ge.heart.pop()
        @game.ge.nb_life--
        @lost()
        if @game.ge.heart.length == 0
            @game.time.events.add Phaser.Timer.SECOND * 2, @endGame, this

            if @game.ge.nb_replay%@game.gameOptions.nativeIntersticielPonderation == 0
                console.log "native"
        else
            @game.time.events.add Phaser.Timer.SECOND * 2, @resetPlayer, this

        return

    jump: ->
        jumpSound = @game.add.audio 'jumpSound'
        jumpSound.play()

    endGame: ->
        @game.ge.remainingTime = Math.round @game.ge.generalTimer.duration/1000

        @game.state.start 'gameOver'
        @cutLoop()

    cutLoop: ->
        @loopSound.destroy()

    isFullScreen: ->
        @game.gameOptions.fullscreen
    lifeInit: ->
        `var heartImg`
        if !@game.ge.nb_life?
            @game.ge.nb_life = @game.gameOptions.life
        
        @game.ge.heart = []
        i = 0

        console.log @game.ge.nb_life

        while i < @game.ge.nb_life
            if @game.gameOptions.fullscreen == false
                if @game.ge.heart.length == 0
                    heartImg = @game.add.image(0, @statusBar.y+15 , 'heart')
                    heartImg.x = @timerBase.graphicsData[0].shape.x + @timerBase.graphicsData[0].shape.width + 20
                    heartImg.y = @statusBar.height*0.5 - heartImg.height*0.5
                else
                    lastElement = @game.ge.heart[@game.ge.heart.length - 1]
                    heartImg = @game.add.image(0, 0, 'heart')
                    heartImg.x = lastElement.x + lastElement.width + 5
                    heartImg.y = lastElement.y

                    lastElement.fixedToCamera = true


                heartImg.fixedToCamera = true
                @game.ge.heart.push heartImg
                i++

            else

                if @game.ge.heart.length == 0
                    heartImg = @game.add.image(0, 28 , 'heart')
                    heartImg.scale.setTo(0.7,0.7)
                    heartImg.x = 140
                    # heartImg.scale.setTo(0.5,0.5);
                else
                    lastElement = @game.ge.heart[@game.ge.heart.length - 1]
                    heartImg = @game.add.image(lastElement.x + lastElement.width + 2, 28, 'heart')
                    lastElement.fixedToCamera = true
                heartImg.fixedToCamera = true
                heartImg.scale.setTo(0.7,0.7);
                @game.ge.heart.push heartImg
                i++
        return
    deadlifeInit: ->
        `var heartImg1`
        @game.ge.deadheart = []
        i = 0
        if @game.gameOptions.fullscreen == false
            while i < @game.gameOptions.life
                if @game.ge.deadheart.length == 0
                    heartImg1 = @game.add.image(0, 0, 'dead')
                    heartImg1.x = @timerBase.graphicsData[0].shape.x + @timerBase.graphicsData[0].shape.width + 20
                    heartImg1.y = @statusBar.height*0.5 - heartImg1.height*0.5
                else
                    lastElement = @game.ge.deadheart[@game.ge.deadheart.length - 1]
                    heartImg1 = @game.add.image(0, 0, 'dead')
                    heartImg1.x = lastElement.x + lastElement.width + 5
                    heartImg1.y = lastElement.y
                    lastElement.fixedToCamera = true
                heartImg1.fixedToCamera = true
                @game.ge.deadheart.push heartImg1
                i++
        else

            while i < @game.gameOptions.life
                if @game.ge.deadheart.length == 0
                    heartImg1 = @game.add.image(0, 28, 'dead')
                    heartImg1.scale.setTo(0.7,0.7)
                    heartImg1.x = 140
                    # heartImg.scale.setTo(0.5,0.5);
                else
                    lastElement = @game.ge.deadheart[@game.ge.deadheart.length - 1]
                    heartImg1 = @game.add.image(lastElement.x + lastElement.width + 2, 28 , 'dead')
                    heartImg1.scale.setTo(0.7,0.7);
                    lastElement.fixedToCamera = true
                heartImg1.fixedToCamera = true
                @game.ge.deadheart.push heartImg1
                i++

        return

