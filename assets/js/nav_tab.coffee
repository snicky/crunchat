class @NavTab

  @navTabClass            = "nav-tab"
  @roomSpaceClass         = "room-space"
  @lobbyId                = "lobby"
  @roomNameAttr           = "data-room-name"
  @templateKey      = "navTab"

  constructor: (roomName) ->
    @roomName = roomName
    @$dom = $(Templates[NavTab.templateKey])
    @$dom.find("a:first").text(@roomName)
    @$dom.attr(NavTab.roomNameAttr,@roomName)
    $("#nav-space").append(@$dom)

  activate: ->
    history.pushState(null, null, "_#{@roomName}")
    $(".#{NavTab.navTabClass}").removeClass("active")
    @$dom.addClass("active")
    @showRoomSpace()

  showRoomSpace: ->
    $(".#{NavTab.roomSpaceClass}").hide()
    $("##{NavTab.lobbyId}").hide()
    Rooms[@roomName].$dom.show()