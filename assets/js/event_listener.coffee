class @EventListener

  constructor: (socket) ->
    @socket = socket
    @tabs   = []
    @bindEvents()
    @catchRoomNameParam()

  joinRoom: (roomName) ->
    if roomName.length < Common.settings.maxStringLength && !Rooms[roomName]
      @socket.emit "joinRoom", 
        roomName : roomName

  leaveRoom: (roomName) ->
    @socket.emit "leaveRoom",
      roomName : roomName

    Rooms[roomName].leave()
    Tabs[roomName].remove()

    @activateLastTab()

  activateLastTab: ->
    lastTab = $("#nav-space .nav-room:last")
    if lastTab.length > 0
      lastRoomName = lastTab.attr(Common.settings.roomNameAttr)
      Tabs[lastRoomName].activate()
    else
      Common.DOM.lobbyNavTab.addClass("active")
      Common.DOM.lobby.show()

  catchRoomNameParam: ->  
    roomNameMatch = window.location.pathname.match(/_\w+/)
    if roomNameMatch
      roomName = roomNameMatch[0].substring(1)
      @joinRoom(roomName)

  bindEvents: ->
    el = @
    
    Common.DOM.lobbyNavTab.on "click", ->
      target = $(this)
      if !target.hasClass("active")
        $(".#{Common.classes.navTab}").removeClass("active")
        target.addClass("active")
        $(".#{Common.classes.roomSpace}").hide()
        Common.DOM.lobby.show()
        return false

    Common.DOM.navSpace.on "click", ".nav-room", ->
      target = $(this)
      roomName = target.attr(Common.settings.roomNameAttr)
      Tabs[roomName].activate()
      return false

    Common.DOM.nicknameChangeButton.click =>
      newNickname = Nickname.change()
      if newNickname
        @socket.emit "updateNickname",
          nickname: newNickname

    Common.DOM.joinButton.click =>
      roomName = Common.DOM.roomNameInput.val()
      @joinRoom(roomName)

    Common.DOM.randomButton.click =>
      @socket.emit "joinRandomRoom"

    $("#main-space").on "click", ".#{Common.classes.closeButton}", ->
      roomName = $(this).attr(Common.settings.roomNameAttr)
      el.leaveRoom(roomName)