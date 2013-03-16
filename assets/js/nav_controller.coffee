class @NavController

  constructor: (socket, roomController) ->
    @socket                 = socket
    @roomController         = roomController
    @navSpaceId             = "nav-space"
    @navTabClass            = "nav-tab"
    @navTabIdPrefix         = "nav-tab-"
    @lobbyNavTabId          = "nav-tab-lobby"
    @navTabTemplateKey      = "navTab"
    @chatSpaceClass         = "chat-space"
    @specialSpaceClass      = "special-space"
    @roomNameAttr           = "data-room-name"
    @specialAttr            = "data-special"
    @roomNameId             = "room-name"
    @joinButtonId           = "join-button"
    @randomButtonId         = "random-button"
    @closeButtonClass       = "btn-close"
    @addRoomIconId          = "add-room-icon"
    @nicknameChangeButtonId = "nickname-change-btn"
    @permStorage            = new SNStorage("perm")
    @anonymousIdRange       = [10000, 99999]
    @nicknameInputId        = "nickname"
    @maxStringLength        = 32
    @assignNickname()
    @initEvents()

  getNavTabId: (roomName) ->
    @navTabIdPrefix + roomName

  pullRoomName: (tab) ->
    navTabId = tab.attr("id")
    navTabId.replace(@navTabIdPrefix,"") if navTabId

  historyPushRoomName: (roomName) ->
    history.pushState(null, null, "_#{roomName}")

  addTab: (roomName) ->
    template = $(Templates[@navTabTemplateKey])
    template.attr("id",@getNavTabId(roomName))
    template.find("a").text(roomName)
    $("##{@navSpaceId}").append(template)
    @activateTab(template)

  removeTab: (roomName) ->
    $("##{@getNavTabId(roomName)}").remove()

  activateTab: (tab) ->
    roomName = @pullRoomName(tab)
    @historyPushRoomName(roomName) if roomName
    $(".#{@navTabClass}").removeClass("active")
    tab.addClass("active")
    @showChatSpace(tab)

  activateLastTab: ->
    $(".#{@navTabClass}:last").addClass("active")

  showChatSpace: (tab) ->
    roomName = @pullRoomName(tab)
    special  = tab.attr(@specialAttr) unless roomName
    $(".#{@chatSpaceClass}").hide()
    $(".#{@specialSpaceClass}").hide()
    if roomName
      $("#room-#{roomName}").show()
    else if special
      $("##{special}").show()
    else
      # raise an error

  showLastChatSpace: ->
    last = $(".chat-space:last")
    if last.length > 0
      last.show()
    else
      $("#lobby").show()

  randomNickname: ->
    "Anonymous" + Math.random_between(@anonymousIdRange[0], @anonymousIdRange[1])

  getNickname: ->
    @permStorage.getItem("nickname")

  assignNickname: ->
    nickname = @getNickname()
    unless nickname
      nickname = @randomNickname()
      @permStorage.setItem("nickname", nickname)
    $("##{@nicknameInputId}").val(nickname)

  changeNickname: (nickname) ->
    previous = @getNickname()
    nickname = $("##{@nicknameInputId}").val()
    changing = nickname != previous
    changing = false if nickname.length > @maxStringLength
    if changing
      nickname = @randomNickname() unless nickname
      @permStorage.setItem("nickname", nickname)
      $("[id^=my]").find(".personal-info:first").text("#{nickname}:")
    changing

  joinRoom: (roomName) ->
    if roomName.length < @maxStringLength && @roomController.rooms.indexOf(roomName) == -1
      @socket.emit "joinRoom", 
        roomName : roomName

  initEvents: ->
    nc = @

    roomNameMatch = window.location.pathname.match(/_\w+/)
    if roomNameMatch
      roomName = roomNameMatch[0].substring(1)
      @joinRoom(roomName)

    $("##{@addRoomIconId}").click ->
      $(this).parent().click()
      return false

    $("##{@navSpaceId}").on "click", ".nav-tab", ->
      target = $(this)
      if !target.hasClass("active")
        nc.activateTab(target)
      return false

    $("##{@nicknameChangeButtonId}").click =>
      if @changeNickname()
        @socket.emit "updateNickname",
          nickname: @getNickname()

    $("##{@joinButtonId}").click =>
      roomName = $("##{@roomNameId}").val()
      @joinRoom(roomName)

    $("##{@randomButtonId}").click =>
      @socket.emit "joinRandomRoom"

    $("#main-space").on "click", ".#{@closeButtonClass}", ->
      roomName = $(this).attr("data-room-name")
      nc.socket.emit "leaveRoom",
        roomName : roomName
      nc.roomController.find(roomName).leaveRoom()
      nc.removeTab(roomName)
      nc.showLastChatSpace()
      nc.activateLastTab()