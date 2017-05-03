###  written on 2017-04-27 ###
#           _ __ ___   ___  _   _ ___  ___
#          | '_ ` _ \ / _ \| | | / __|/ _ \
#          | | | | | | (_) | |_| \__ \  __/
#          |_| |_| |_|\___/ \__,_|___/\___|

class Phacker.Game.Mouse

    constructor: (@gm, @spt) ->
        @_fle_ = 'Mouse'

        @pm = @gm.parameters.btn =
            dx: @gm.parameters.bg.w / 6 # space between the 2 buttons
            y :  500
            w: 55
            h: 55
        @pm.y = @gm.parameters.bg.h - @pm.h - 20
        @pm.leftX  = @gm.parameters.bg.w / 2 - @gm.parameters.bg.w / 10 - @pm.w
        @pm.rightX = @gm.parameters.bg.w / 2 + @gm.parameters.bg.w / 10

        @draw_buttons()

    #.----------.----------
    # draw button and define events
    #.----------.----------
    draw_buttons:()->
        # for left btn
        @l_btn = @gm.add.button @pm.leftX, @pm.y, 'left_btn', @on_tapUp, @, 1, 1, 0
        @l_btn.fixedToCamera = true
        @l_btn.onInputDown.add @on_tapDownLeft, @

        # for right btn
        @r_btn = @gm.add.button @pm.rightX, @pm.y, 'right_btn', @on_tapUp, @, 1, 1, 0
        @r_btn.fixedToCamera = true
        @r_btn.onInputDown.add @on_tapDownRight, @

    #.----------.----------
    # button events
    #.----------.----------
    on_tapUp: ->
        @spt.body.velocity.x = @gm.parameters.spt.vx0 # back to initial sprite velocity
        #console.log @_fle_,': ','UP',@spt.body.velocity.x

    on_tapDownLeft: ->
        @spt.body.velocity.x -= @gm.parameters.spt.dvx0 # decrease sprite velocity
        #console.log @_fle_,': ','Down',@spt.body.velocity.x

    on_tapDownRight: ->
        @spt.body.velocity.x += @gm.parameters.spt.dvx0 # increase sprite velocity
        #console.log @_fle_,': ','Down',@spt.body.velocity.x