class @NavTab

  @findActive: ->
    $(".#{Common.classes.navTab}.active")

  @findActiveRoomName: ->
    @findActive().attr(Common.settings.roomNameAttr)

  @clearAll: ->
    $(".#{Common.classes.navTab}").removeClass("active")
    $(".#{Common.classes.roomSpace}").hide()
    Lobby.hide()

  @activateLastTab: ->
    lastTab = Common.DOM.navSpace.find(".#{Common.classes.navRoom}:last")
    if lastTab.length > 0
      lastRoomName = lastTab.attr(Common.settings.roomNameAttr)
      Tabs[lastRoomName].activate()
    else
      Lobby.activate()

  @activateNext: ->
    next = @findActive().next(".#{Common.classes.navTab}")
    if next.length == 0
      return false
    else
      roomName = next.attr(Common.settings.roomNameAttr)
      Tabs[roomName].activate()

  @activateNextOrLobby: ->
    Lobby.activate() unless @activateNext()

  constructor: (roomName) ->
    @roomName      = roomName
    @$dom          = $(Templates.NavTab)
    @$link         = @$dom.find("a:first")
    @$link.text(@roomName)
    @$dom.attr(Common.settings.roomNameAttr,@roomName)
    Common.DOM.navSpace.append(@$dom)
    @activate()

  hitIndicator: ->
    unless @$indicator
      @$indicator = $(Templates.Indicator)
      @$link.prepend(@$indicator)
    else if @$indicator.hasClass("icon-circle")
      @$indicator.removeClass("icon-circle").addClass("icon-circle-blank")
    else
      @$indicator.removeClass("icon-circle-blank").addClass("icon-circle")

  clearIndicator: ->
    if @$indicator
      @$indicator.remove()
      @$indicator = null

  activate: ->
    @clearIndicator()
    history.pushState(null, null, "_#{@roomName}")
    NavTab.clearAll()
    @$dom.addClass("active")
    Rooms[@roomName].$dom.show()
    Rooms[@roomName].users.me.focusOnTextarea()
    Common.titleChanger.refreshTitle()

  remove: ->
    @$dom.remove()
    delete Tabs[@roomName]