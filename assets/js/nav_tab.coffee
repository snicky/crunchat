class @NavTab

  constructor: (roomName) ->
    @roomName = roomName
    @$dom = $(Templates.NavTab)
    @$dom.find("a:first").text(@roomName)
    @$dom.attr(Settings.roomNameAttr,@roomName)
    $("#nav-space").append(@$dom)

  activate: ->
    history.pushState(null, null, "_#{@roomName}")
    $(".#{Settings.classes.navTab}").removeClass("active")
    @$dom.addClass("active")
    @showRoomSpace()

  showRoomSpace: ->
    $(".#{Settings.classes.roomSpace}").hide()
    $("##{Settings.ids.lobby}").hide()
    Rooms[@roomName].$dom.show()