class @NavController

  constructor: (socket, roomController) ->
    @socket                 = socket
    @roomController         = roomController
    @selfId                 = "nav-space"
    @navTabClass            = "nav-tab"
    @navTabTemplateKey      = "navTab"
    @chatSpaceClass         = "chat-space"
    @specialSpaceClass      = "special-space"
    @roomNameAttr           = "data-room-name"
    @specialAttr            = "data-special"
    @roomNameId             = "room-name"
    @joinButtonId           = "join-button"
    @closeButtonClass       = "btn-close"
    @nicknameChangeButtonId = "nickname-change-btn"
    @permStorage            = new SNStorage("perm")
    @anonymousIdRange       =  [10000, 99999]
    @nicknameInputId        = "nickname"
    @maxStringLength        = 32
    @assignNickname()
    @initEvents()

  historyPushRoomName: (roomName) ->
    history.pushState(null, null, "_#{roomName}")

  addTab: (roomName) ->
    template = $(Templates[@navTabTemplateKey])
    template.attr(@roomNameAttr,roomName)
    template.find("a").text(roomName)
    $("##{@selfId}").append(template)
    @activateTab(template)

  activateTab: (tab) ->
    roomName = tab.attr(@roomNameAttr)
    @historyPushRoomName(roomName) if roomName
    $(".#{@navTabClass}").removeClass("active")
    tab.addClass("active")
    @showChatSpace(tab)

  activateLastTab: ->
    $(".#{@navTabClass}").last().addClass("active")

  removeTab: (roomName) ->
    $(".#{@navTabClass}[#{@roomNameAttr}=#{roomName}]").remove()

  showChatSpace: (tab) ->
    $tab = $(tab)
    roomName = $tab.attr(@roomNameAttr)
    special  = $tab.attr(@specialAttr) unless roomName
    $(".#{@chatSpaceClass}").hide()
    $(".#{@specialSpaceClass}").hide()
    if roomName
      $(".#{@chatSpaceClass}[#{@roomNameAttr}=#{roomName}]").show()
    else if special
      $("##{special}").show()
    else
      # raise an error

  showLastChatSpace: ->
    chatSpaces = $(".chat-space")
    if chatSpaces.length > 0
      chatSpaces.last().show()
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
    roomNameMatch = window.location.pathname.match(/_\w+/)
    if roomNameMatch
      roomName = roomNameMatch[0].substring(1)
      @joinRoom(roomName)
    
    $(".icon-plus").click ->
      $(this).parent().click()
      return false

    $("##{@selfId}").on "click", "a", (event) =>
      target = $(event.target).parent()
      if !target.hasClass("active")
        @activateTab(target)
      return false

    $("##{@nicknameChangeButtonId}").click =>
      if @changeNickname()
        @socket.emit "updateNickname",
          nickname: @getNickname()

    $("##{@joinButtonId}").click =>
      roomName = $("##{@roomNameId}").val()
      @joinRoom(roomName)

    $("#main-space").on "click", ".#{@closeButtonClass}", (event) =>
      roomName = $(event.target).parents(".chat-space").attr("data-room-name")
      @socket.emit "leaveRoom",
        roomName : roomName
      @roomController.find(roomName).leaveRoom()
      @removeTab(roomName)
      @showLastChatSpace()
      @activateLastTab()