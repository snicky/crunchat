class @NavTab

  constructor: (roomName) ->
    @roomName = roomName
    @$dom = $(Templates.NavTab)
    @$dom.find("a:first").text(@roomName)
    @$dom.attr(Common.settings.roomNameAttr,@roomName)
    $("#nav-space").append(@$dom)
    @activate()

  activate: ->
    history.pushState(null, null, "_#{@roomName}")
    $(".#{Common.classes.navTab}").removeClass("active")
    @$dom.addClass("active")
    $(".#{Common.classes.roomSpace}").hide()
    Lobby.hide()
    Rooms[@roomName].$dom.show()

  remove: ->
    @.$dom.remove()
    delete Tabs[@roomName]