socket = io.connect("http://web1.tunnlr.com:11630")

chatController = new ChatController()
navController  = new NavController(socket, chatController)

loadSocketCallbacks = ->

  socket.emit "updateNickname",
    nickname : navController.getNickname()

  socket.on "confirmJoiningRoom", (data) ->

    roomName = data.roomName

    # alert("Joined room ##{data.roomName} with id #{data.clientId}")

    navController.addTab(roomName)

    chatController.for(roomName).activate (diff, caretPos) ->
      socket.emit "textUpdate",
        roomName : roomName
        diff     : diff
        caretPos : caretPos

    for data in data.clients
      chatController.for(roomName).addBox(data)

  socket.on "distributeTextUpdate", (data) ->
    chatController.for(data.roomName).distributeText(data)

  socket.on "announceNewClient", (data) ->
    chatController.for(data.roomName).addBox(data)

  socket.on "announceClientRemoval", (data) ->
    chatController.for(data.roomName).removeBox(data.clientId)

  socket.on "announceNicknameChange", (data) ->
    chatController.distributeNickname(data)

  socket.on "refuseJoiningRoom", (data) ->
    msg = "Couldnt join room ##{data.roomName}. Reason: "
    msg = if data.reason == "full"
      msg += "ROOM FULL"
    alert(msg)

$(loadSocketCallbacks)


###
    $(window).unload ->
      socket.emit "leaveRoom",
        roomName : roomName
###