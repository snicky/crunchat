class @NavController

  constructor: (chatController) ->
    @chatController         = chatController
    @tabs = []
    @navSpaceId             = "nav-space"
    @navTabClass            = "nav-tab"
    @lobbyNavTabId          = "nav-lobby"
    @roomSpaceClass         = "room-space"
    @lobbyId                = "lobby"
    @navTabTemplateKey      = "navTab"
    @roomNameId             = "room-name"
    @joinButtonId           = "join-button"
    @randomButtonId         = "random-button"
    @closeButtonClass       = "btn-close"
    @addRoomIconId          = "add-room-icon"
    @nicknameChangeButtonId = "nickname-change-btn"
    @roomNameAttr           = "data-room-name"
    @permStorage            = new SNStorage("perm")
    @maxStringLength        = 32
    @initEvents()

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
      $("##{@lobbyNavTabId}").addClass("active")
      $("#lobby").show()

  initEvents: ->
    nc = @
    $("##{@lobbyNavTabId}").on "click", ->
      target = $(this)
      if !target.hasClass("active")
        $(".#{nc.navTabClass}").removeClass("active")
        target.addClass("active")
        $(".#{nc.roomSpaceClass}").hide()
        $("##{nc.lobbyId}").show()

    $("##{@navSpaceId}").on "click", ".nav-room", ->
      target = $(this)
      if !target.hasClass("active")
        roomName = target.attr(nc.roomNameAttr)
        nc.findTab(roomName).activate()
      return false

    $("##{@nicknameChangeButtonId}").click =>
      newNickname = Nickname.change()
      if newNickname
        @chatController.socket.emit "updateNickname",
          nickname: newNickname

    $("##{@joinButtonId}").click =>
      roomName = $("##{@roomNameId}").val()
      @chatController.joinRoom(roomName)

    $("##{@randomButtonId}").click =>
      @chatController.emit "joinRandomRoom"

    $("#main-space").on "click", ".#{@closeButtonClass}", ->
      roomName = $(this).attr(nc.roomNameAttr)
      nc.chatController.socket.emit "leaveRoom",
        roomName : roomName
      Rooms[roomName].leave()
      nc.removeTab(roomName)
      nc.activateLastTab()