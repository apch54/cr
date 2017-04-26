class Phacker.NextLevelState extends Phacker.BaseState
  textColor: '#ffffff'

  update: ->
    if @clickableLevel.alive
      if @nextLevelScaleDirection == 'up'
        @clickableLevel.scale.x += 0.005
        @clickableLevel.scale.y += 0.005

        @nextLevelScaleDirection = 'down' if @clickableLevel.scale.x > 1.1

      if @nextLevelScaleDirection == 'down'
        @clickableLevel.scale.x -= 0.005
        @clickableLevel.scale.y -= 0.005

        @nextLevelScaleDirection = 'up' if @clickableLevel.scale.x < 0.9

  create: ->

    @nextLevelScaleDirection = 'up'

    hackBottomFullScreen?('win');

    nextLevelSound = @game.add.audio 'nextLevelSound'
    nextLevelSound.play()


    duration = Math.round( (@game.ge.generalTimer._now-@game.ge.generalTimer._started)/1000 );

    @game.input.touch.preventDefault = false

    @game.ge.resultTitle = @game.add.text(0, 0, 'Score : ',
      font: 'normal 17pt Helvetica'
      fill: '#585858')
    @game.ge.resultTitle.x = 200
    @game.ge.resultTitle.y = 200


    background = @game.add.image 0, 0, "win_bg"
    area = @game.add.image 0, 0, "win_area"
    logo = @game.add.image 0, 0, "level_complete"

    replayButton = @game.add.button 0, 0, 'continue_button', ->
        if @game.gameOptions.durationByLevel
            delete @game.ge.remainingTime

        @game.state.start 'jeu'

    , 0, 1, 0

    area.x = @game.width*0.5 - area.width*0.5
    area.y = @game.height*0.5 - area.height*0.5

    replayButton.x = @game.width*0.5 - replayButton.width*0.5
    replayButton.y = @game.height - replayButton.height - 22

    logo.x = @game.width*0.5 - logo.width*0.5
    logo.y = area.y*0.5 - logo.height*0.5

    finalScoreTitle = @game.add.text 0, 0, "Score : " + @game.ge.score ,
        font: 'normal 30pt Helvetica'
        fill: @textColor
        align: 'center'
    finalScoreTitle.x = @game.width*0.5 - finalScoreTitle.width*0.5
    finalScoreTitle.y = area.y + 15

    row = 0
    spacingButtons = 15
    for lvlNumber in [0..8]
    	col = ( lvlNumber % 3 ) + 1

    	if lvlNumber >= @game.ge.level
    		key = 'lock'
    	else
    		if lvlNumber < @game.ge.level-1
    			key = 'level_hover'+(lvlNumber+1)
    		else
    			key = 'level'+(lvlNumber+1)

    	button = @game.add.image 0, 0, key


    	#Placements X
    	if col == 1
    		row++
    		button.x = area.x + area.width*0.5 - button.width*0.5 - button.width - spacingButtons

    	if col == 2
    		#center x
    		button.x = area.x + area.width*0.5 - button.width*0.5

    	if col == 3
    		button.x = area.x + area.width*0.5 - button.width*0.5 + button.width + spacingButtons

    	#Placements Y
    	if row == 1
    		button.y = finalScoreTitle.y + finalScoreTitle.height + spacingButtons

    	if row == 2
    		button.y = finalScoreTitle.y + finalScoreTitle.height + spacingButtons + button.height + spacingButtons

    	if row == 3
    		button.y = finalScoreTitle.y + finalScoreTitle.height + spacingButtons + button.height + spacingButtons + button.height + spacingButtons

    	if lvlNumber+1 == @game.ge.level
    		button.anchor.setTo(0.5);
    		button.inputEnabled = true
    		button.events.onInputDown.addOnce ( ->
                if @game.gameOptions.durationByLevel
                    delete @game.ge.remainingTime

                @game.state.start 'jeu'

            ).bind @

    		@clickableLevel = button
	    	button.y += button.height/2
	    	button.x += button.width/2

    super()