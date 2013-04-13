class @NavTab

  @findActive: ->
    $(".#{Common.classes.navTab}.active")

  @findActiveRoomName: ->
    @findActive().attr(Common.settings.roomNameAttr)

  @activateLastTab: ->
    lastTab = Common.DOM.navSpace.find(".#{Common.classes.navRoom}:last")
    if lastTab.length > 0
      lastRoomName = lastTab.attr(Common.settings.roomNameAttr)
      Tabs[lastRoomName].activate()
    else
      @activateLobby()

  @activateLobby: ->
    Common.DOM.lobbyNavTab.addClass("active")
    Lobby.show()
    history.pushState(null, null, "/")
    Common.titleChanger.refreshTitle()

  constructor: (roomName) ->
    @roomName      = roomName
    @letterCounter = 0
    @$dom          = $(Templates.NavTab)
    @$link         = @$dom.find("a:first")
    @$link.text(@roomName)
    @$dom.attr(Common.settings.roomNameAttr,@roomName)
    $("#nav-space").append(@$dom)
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
    $(".#{Common.classes.navTab}").removeClass("active")
    @$dom.addClass("active")
    $(".#{Common.classes.roomSpace}").hide()
    Lobby.hide()
    Rooms[@roomName].$dom.show()
    Rooms[@roomName].users.me.focusOnTextarea()
    Common.titleChanger.refreshTitle()

  remove: ->
    @$dom.remove()
    delete Tabs[@roomName]