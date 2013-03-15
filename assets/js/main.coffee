socket = io.connect("http://web1.tunnlr.com:11630")

roomController = new RoomController()
navController  = new NavController(socket, roomController)

loadSocketCallbacks = ->

  socket.emit "updateNickname",
    nickname : navController.getNickname()

  socket.on "confirmJoiningRoom", (data) ->

    roomName = data.roomName

    # alert("Joined room ##{data.roomName} with id #{data.clientId}")

    navController.addTab(roomName)

    roomController.for(roomName).activate (diff, caretPos) ->
      socket.emit "textUpdate",
        roomName : roomName
        diff     : diff
        caretPos : caretPos

    for data in data.clients
      roomController.for(roomName).addBox(data)

  socket.on "distributeTextUpdate", (data) ->
    roomController.for(data.roomName).distributeText(data)

  socket.on "announceNewClient", (data) ->
    roomController.for(data.roomName).addBox(data)

  socket.on "announceClientRemoval", (data) ->
    roomController.for(data.roomName).removeBox(data.clientId)

  socket.on "announceNicknameChange", (data) ->
    roomController.distributeNickname(data)

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