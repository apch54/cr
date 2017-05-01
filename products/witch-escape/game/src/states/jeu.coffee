#          ____
#      .-'     '-.
#   .'     _)\_    '.
#  / fc    //}       \
# |       (_;\        |
# | >|||---> \`--     |
#  \      /__/       /
#    .     ``      .'
#      '-._____.-'


class @YourGame extends Phacker.GameState

    update: ->
        super() #Required
        @_fle_ = 'Update'

        if @game.physics.arcade.collide @spt, @socleO.pfm
            @spt.body.velocity.x = @spriteO.pm.vx0

        mess = @spriteO.collide_emy @enemiesO.emy
        if mess is 'good' then @win()
        else if mess is 'bad'  then @lostLife()
        #console.log @_fle_,': ',mess

        @cameraO.move @spt, @socleO
        @socleO.move_clouds_boats @spt
        @enemiesO.create_destroy()

        @ghostO.check_x()       # check location on x axis
        mess2 = @ghostO.check_overlap @spt #check ghost overlaping sprite
        #console.log @_fle_,': ',mess2

        mess3 = @laserO.check_x @spt
        #console.log @_fle_,': ',mess3

    resetPlayer: ->
        @socleO.pfm.x = @spt.x- @socleO.pm.pfm.w + 60
        @spt.body.velocity.x = 0
        @spt.body.velocity.y = @spriteO.pm.vy.low
        @spt.y = @socleO.pm.pfm.y0 - 70
        @enemiesO.destroy_behind @spt
        @spriteO.pm.lost = false

        #console.log "Reset the player", @spriteO.spt.body.velocity.x , @spriteO.pm.vx0

    create: ->
        super() #Required

        @game.physics.startSystem(Phaser.Physics.ARCADE)
        @game.world.setBounds(-1000, -1000, 300000, 2000) # offset x, offset y, w, h

        @socleO     = new Phacker.Game.Socle @game
        @enemiesO   = new Phacker.Game.Enemies @game

        @spriteO    = new Phacker.Game.Sprite @game
        @spt = @spriteO.spt

        @mouseO     = new Phacker.Game.Mouse @game, @spriteO.spt
        @cameraO    = new Phacker.Game.My_camera @game
        @ghostO     = new Phacker.Game.Ghost @game
        @laserO     = new Phacker.Game.Laser @game
        #@enemiesO.bind @spriteO, @ghostO


###  LOGIC OF YOUR GAME
#
lostBtn = @game.add.text(0, 0, "Bad Action");
lostBtn.inputEnabled = true;
lostBtn.y = @game.height*0.5 - lostBtn.height*0.5
lostBtn.events.onInputDown.add ( ->
    @lost()
).bind @

    bonusBtn = @game.add.text(0, 0, "Bonus");
bonusBtn.inputEnabled = true;
bonusBtn.y = @game.height*0.5 - bonusBtn.height*0.5 + 50
bonusBtn.x = @game.width - bonusBtn.width
bonusBtn.events.onInputDown.add ( ->
    @winBonus()
).bind @

#Placement specific for mobile

if @game.gameOptions.fullscreen
        lostBtn.x = @game.width*0.5 - lostBtn.width*0.5
        lostBtn.y = @game.height*0.25

        bonusBtn.x = @game.width*0.5 - winBtn.width*0.5
        bonusBtn.y = @game.height*0.5 + 50

###


