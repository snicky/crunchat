class @EventListener

  constructor: (socket) ->
    @socket       = socket
    @tabs         = []
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

    Rooms[roomName].remove()
    Tabs[roomName].remove()

    NavTab.activateLastTab()

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
        Common.titleChanger.refreshTitle()
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

    Common.DOM.soundSwitchButton.on "click", ->
      if Common.soundPlayer.on
        Common.DOM.soundSwitchButtonIcon
          .addClass("icon-volume-off")
          .removeClass("icon-volume-up")
      else
        Common.DOM.soundSwitchButtonIcon
          .addClass("icon-volume-up")
          .removeClass("icon-volume-off")
      Common.soundPlayer.toggle()

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

    Common.DOM.mainSpace.on "click", ".#{Common.classes.closeButton}", ->
      roomName = $(this).parent().attr(Common.settings.roomNameAttr)
      el.leaveRoom(roomName)

    Common.DOM.mainSpace.on "click", ".#{Common.classes.roomPrivacyCheckbox}", ->
      $this = $(this)
      roomName = $this.closest(".#{Common.classes.roomControl}").attr(Common.settings.roomNameAttr)
      el.socket.emit "toggleRoomPrivacy", 
        roomName   : roomName
        boolSwitch : $this.prop("checked")

    $(window).focus ->
      Common.titleChanger.stopBlinking()