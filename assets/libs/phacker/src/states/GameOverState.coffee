pointToLevel = (ptl1, ptnl, x) ->
    if x == 1
        return ptl1

    return pointToLevel(ptl1, ptnl, x-1) + ( pointToLevel(ptl1, ptnl, x-1) * ptnl );

class Phacker.GameOverState extends Phacker.BaseState
  textColor: '#ffffff'

  create: ->

    hackBottomFullScreen?('lose');

    gameOverStateSound = @game.add.audio 'gameOverStateSound'
    gameOverStateSound.play()
    
    @game.input.touch.preventDefault = false

    duration = Math.round( (@game.ge.generalTimer._now-@game.ge.generalTimer._started)/1000 );

    nb_cvr = Math.round pointToLevel @game.gameOptions.pointToLevel1, @game.gameOptions.percentToNextLevel, @game.gameOptions.winningLevel

    callback @game.gameOptions.loseCallback, @game.ge.score, @game.ge.nb_replay, @game.ge.heart.length, duration, nb_cvr, false


    background = @game.add.image 0, 0, "gameover_bg"
    area = @game.add.image 0, 0, "gameover_area"
    logo = @game.add.image 0, 0, "gameover_logo"
    character = @game.add.image 0, 0, "gameover_character"

    replayButton = @game.add.button(0, 0, 'retry_button', null, 0, 1, 2)

    replayButton.events.onInputDown.addOnce ( () ->
        @game.ge.score = 0

        if @game.gameOptions.pub_ads_game
            console.log "AFG"
            afg()

        @game.ge.nb_replay++;

        delete @game.ge.nb_life
        delete @game.ge.remainingTime

        @game.ge.level = 0

        @game.state.start 'jeu'
    ).bind @

    closeButton = @game.add.button(0, 0, 'close_btn', (->
        window.location = @game.gameOptions.closeRedirectLose
    ), 0, 1, 0)


    area.x = @game.width*0.5 - area.width*0.5
    area.y = @game.height*0.5 - area.height*0.5

    replayButton.x = @game.width*0.5 - replayButton.width*0.5
    replayButton.y = @game.height - replayButton.height - 22

    logo.x = @game.width*0.5 - logo.width*0.5
    logo.y = area.y*0.5 - logo.height*0.5

    character.x = @game.width*0.5 - character.width*0.5
    character.y = area.y + area.height - character.height

    closeButton.x = area.x + area.width - (closeButton.width*0.5)
    closeButton.y = area.y - closeButton.height*0.5

    finalScoreTitle = @game.add.text 0, 0, "Score :\n" + @game.ge.score ,
        font: 'normal 36pt Helvetica'
        fill: @textColor
        align: 'center'
    finalScoreTitle.x = @game.width*0.5 - finalScoreTitle.width*0.5
    finalScoreTitle.y = area.y + (character.y - area.y)*0.5 - finalScoreTitle.height*0.5

    if isNativeMode and @game.isAdmobEligible
        finalScoreTitle.setText "Score : " + @game.ge.score
        finalScoreTitle.fontSize = 30
        finalScoreTitle.fontWeight = 'bold'
        finalScoreTitle.x = @game.width*0.5 - finalScoreTitle.width*0.5
        finalScoreTitle.y = area.y + 15

        videoIncent = @game.add.sprite 0, 0, 'incent_video'

        videoIncent.x = @game.width*0.5 - videoIncent.width*0.5
        videoIncent.y = finalScoreTitle.y + finalScoreTitle.height + 15

        videoIncent.inputEnabled = true

        videoIncent.events.onInputDown.add ->
            console.log 'INCENT ADMOB'

            videoIncent.destroy()
        , @

        videoIncent.animations.add 'run'
        videoIncent.animations.play 'run', 15, true

    super()
