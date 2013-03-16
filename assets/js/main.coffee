socket = io.connect("http://localhost:3000")

window.Rooms = {}
chatController = new ChatController(socket)
navController  = new NavController(chatController)

initialize = ->

  socket.emit "updateNickname",
    nickname : Nickname.get()

  socket.on "confirmJoiningRoom", (data) ->

    roomName = data.roomName

    # alert("Joined room ##{data.roomName} with id #{data.clientId}")
    Rooms[roomName] = new Room(roomName)
    navController.addTab(roomName)

    Rooms[roomName].users.me.activateMyTextarea (diff, caretPos) ->
      socket.emit "textUpdate",
        roomName : roomName
        diff     : diff
        caretPos : caretPos

    for data in data.clients
      Rooms[roomName].addUser(data)

  socket.on "distributeTextUpdate", (data) ->
    Rooms[data.roomName].users[data.clientId].distributeText(data)

  socket.on "announceNewClient", (data) ->
    Rooms[data.roomName].addUser(data)

  socket.on "announceClientRemoval", (data) ->
    Rooms[data.roomName].removeUser(data.clientId)

  socket.on "announceNicknameChange", (data) ->
    for roomName,room of Rooms
      subject = room.users[data.clientId]
      if subject
        subject.changeNickname(data.nickname)

  socket.on "refuseJoiningRoom", (data) ->
    msg = "Couldnt join room ##{data.roomName}. Reason: "
    msg = if data.reason == "full"
      msg += "ROOM FULL"
    alert(msg)

  roomNameMatch = window.location.pathname.match(/_\w+/)
  if roomNameMatch
    roomName = roomNameMatch[0].substring(1)
    chatController.joinRoom(roomName)

$(initialize)


###
    $(window).unload ->
      socket.emit "leaveRoom",
        roomName : roomName
###