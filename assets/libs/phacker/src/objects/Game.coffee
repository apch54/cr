class Phacker.Game

    constructor: (options) ->
        
        @gameOptions = options
        @gameState = Phacker.GameState
        @countGCSRelaunch = 0
        if options.gcs
            @GCSElig = true
        else
            @GCSElig = false

        if !@gameOptions.nativeIntersticielPonderation
            @gameOptions.nativeIntersticielPonderation = 1

        if !options.fullscreen
            @game = new (Phaser.Game)(768, 500, Phaser.CANVAS, 'game-container', null, true)
        else
            @game = new (Phaser.Game)(375, 559, Phaser.CANVAS, 'game-container', null, true)

        #Register States to state manager
        @game.state.add 'loader', Phacker.LoaderState
        @game.state.add 'intro', Phacker.StartState
        @game.state.add 'jeu', @gameState
        @game.state.add 'gameOver', Phacker.GameOverState
        @game.state.add 'win', Phacker.WinState
        @game.state.add 'nextLevel', Phacker.NextLevelState
        @game.gameOptions = options
        @game.ge = {}

        @game.isAdmobEligible = false

    setGameState: (state) ->
        @gameState = state
        @game.state.add 'jeu', @gameState

    setSpecificAssets: (cb) ->
        Phacker.LoaderState.prototype.specificAssets = cb
        @game.state.add 'loader', Phacker.LoaderState

    setTextColorGameOverState: (color) ->
        Phacker.GameOverState.prototype.textColor = color

    setTextColorWinState: (color) ->
         Phacker.WinState.prototype.textColor = color
         Phacker.NextLevelState.prototype.textColor = color

    setTextColorStatus: (color) ->
        Phacker.GameState.prototype.statusBarTextColor = color

    setOneTwoThreeColorLoading: (color) ->
        Phacker.LoaderState.prototype.OneTwoThreeColor = color

    setOneTwoThreeColorIntro: (color) ->
        Phacker.StartState.prototype.OneTwoThreeColor = color

    setLoaderColor: (color) ->
        Phacker.LoaderState.prototype.loaderColor = color

    setTimerColor: (color) ->
        Phacker.GameState.prototype.timerColor = color

    setTimerBgColor: (color) ->
        Phacker.GameState.prototype.timerBgColor = color

    GCSNotElig: ->
        @GCSElig = false

    GCSRelaunch: ->
        if @GCSElig
            if @countGCSRelaunch == 0
                @gameOptions.duration = @gameOptions.duration_refill
                @gameOptions.life = @gameOptions.life_refill
                @game.state.start 'jeu'

                @countGCSRelaunch++

    IncentAdmobRelaunch: ->
        if isNativeMode and @game.isAdmobEligible
            if !@gameOptions.incent_admob_life_refill
                @game.ge.nb_life = 1
            else
                @game.ge.nb_life = @gameOptions.incent_admob_life_refill

            if !@gameOptions.incent_admob_relaunch_preserve_time? or !@gameOptions.incent_admob_relaunch_preserve_time
                delete @game.ge.remainingTime
                
            @game.state.start 'jeu'

    IncentAdmobEligible: ->
        if isNativeMode
            @game.isAdmobEligible = true

    run: ->
        @game.state.start 'loader'
