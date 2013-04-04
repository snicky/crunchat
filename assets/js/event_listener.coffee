class @EventListener

  constructor: (socket) ->
    @socket = socket
    @tabs   = []
    @bindEvents()
    @catchRoomNameParam()

  joinRoom: (roomName) ->
    msg = if Rooms[roomName]
      "You are already in this room!"
    else if roomName.length > Common.settings.maxStringLength
      "The room name can't be longer than 
        #{Common.settings.maxStringLength} characters."
    else if roomName.match(/[^\w]/)
      "The room name contains illegal characters (only letters, digits and underscores are allowed)."

    if msg
      Lobby.setLobbyInfo(msg)
    else
      Lobby.hide()
      Common.spinner.spin(Common.DOM.mainSpinner)
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
      Lobby.show()

  catchRoomNameParam: ->  
    roomNameMatch = window.location.pathname.match(/_\w+/)
    if roomNameMatch
      roomName = roomNameMatch[0].substring(1)
      @joinRoom(roomName)
    else
      Common.DOM.joinForm.show()

  bindEvents: ->
    el = @
    
    Common.DOM.lobbyNavTab.on "click", ->
      target = $(this)
      if !target.hasClass("active")
        $(".#{Common.classes.navTab}").removeClass("active")
        target.addClass("active")
        $(".#{Common.classes.roomSpace}").hide()
        Lobby.show()
        return false

    Common.DOM.navSpace.on "click", ".nav-room", ->
      target = $(this)
      roomName = target.attr(Common.settings.roomNameAttr)
      Tabs[roomName].activate()
      return false

    Common.DOM.nicknameInput.keypress (e) ->
      if e.which == 13
        Common.DOM.nicknameChangeButton.click()

    Common.DOM.nicknameChangeButton.click =>
      newNickname = Nickname.change()
      if newNickname
        @socket.emit "updateNickname",
          nickname: newNickname

    Common.DOM.roomNameInput.keypress (e) ->
      if e.which == 13
        Common.DOM.joinButton.click()

    Common.DOM.joinButton.click =>
      roomName = Common.DOM.roomNameInput.val()
      @joinRoom(roomName)

    Common.DOM.randomButton.click =>
      Lobby.hide()
      Common.spinner.spin(Common.DOM.mainSpinner)
      @socket.emit "joinRandomRoom"

    $("#main-space").on "click", ".#{Common.classes.closeButton}", ->
      roomName = $(this).parent().attr(Common.settings.roomNameAttr)
      el.leaveRoom(roomName)

    $("#main-space").on "click", ".#{Common.classes.roomPrivacyCheckbox}", ->
      $this = $(this)
      roomName = $this.parent().attr(Common.settings.roomNameAttr)
      el.socket.emit "toggleRoomPrivacy", 
        roomName   : roomName
        boolSwitch : $this.prop("checked")