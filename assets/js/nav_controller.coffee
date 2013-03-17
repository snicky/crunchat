class @NavController

  constructor: (socket) ->
    @socket = socket
    @tabs   = []
    @initEvents()
    @catchRoomNameParam()

  joinRoom: (roomName) ->
    if roomName.length < Settings.maxStringLength && !Rooms[roomName]
      @socket.emit "joinRoom", 
        roomName : roomName

  catchRoomNameParam: ->  
    roomNameMatch = window.location.pathname.match(/_\w+/)
    if roomNameMatch
      roomName = roomNameMatch[0].substring(1)
      @joinRoom(roomName)

  addTab: (roomName) ->
    tab = new NavTab(roomName)
    tab.activate()
    @tabs.push(tab)

  findTab: (roomName) ->
    _.find @tabs, (tab) -> 
      tab.roomName == roomName

  removeTab: (roomName) ->
    tab = @findTab(roomName)
    tab.$dom.remove()
    @tabs.splice(@tabs.indexOf(tab), 1)

  activateLastTab: ->
    lastTab = @tabs[@tabs.length-1]
    if lastTab
      lastTab.activate()
    else
      $("##{Settings.ids.lobbyNavTab}").addClass("active")
      $("#lobby").show()

  initEvents: ->
    nc = @
    $("##{Settings.ids.lobbyNavTab}").on "click", ->
      target = $(this)
      if !target.hasClass("active")
        $(".#{Settings.classes.navTab}").removeClass("active")
        target.addClass("active")
        $(".#{Settings.classes.roomSpace}").hide()
        $("##{Settings.ids.lobby}").show()
        return false

    $("##{Settings.ids.navSpace}").on "click", ".nav-room", ->
      target = $(this)
      roomName = target.attr(Settings.roomNameAttr)
      nc.findTab(roomName).activate()
      return false

    $("##{Settings.ids.nicknameChangeButton}").click =>
      newNickname = Nickname.change()
      if newNickname
        @socket.emit "updateNickname",
          nickname: newNickname

    $("##{Settings.ids.joinButton}").click =>
      roomName = $("##{Settings.ids.roomNameInput}").val()
      @joinRoom(roomName)

    $("##{Settings.ids.randomButton}").click =>
      @socket.emit "joinRandomRoom"

    $("#main-space").on "click", ".#{Settings.classes.closeButton}", ->
      roomName = $(this).attr(Settings.roomNameAttr)
      nc.socket.emit "leaveRoom",
        roomName : roomName
      Rooms[roomName].leave()
      nc.removeTab(roomName)
      nc.activateLastTab()