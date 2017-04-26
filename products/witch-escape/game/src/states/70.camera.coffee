###  ecrit par fc le 2017-03-31  ###
#    ___
#  / __|  __ _   _ __
# | |__  / _` | | '  \
#  \___| \__,_| |_|_|_|


class Phacker.Game.My_camera

    constructor: (@gm) ->
        @_fle_ = 'Camera'
        @pm = @gm.parameters.cam = {}

        @pm =
            offset: if @gm.gameOptions.fullscreen then 60 else 100   # left offset for camera
            speed: 5    # cam speed on left

    #.----------.----------
    #move camera on left at speed @pm.speed
    #.----------.----------

    move: (spt,socle)->
        if spt.x < @gm.parameters.pfm.w then return # game begining
        if (@gm.camera.x - spt.x + @pm.offset) < -@pm.speed
            @gm.camera.x += @pm.speed # for time reseting : not all at once
        else @gm.camera.x = spt.x - @pm.offset