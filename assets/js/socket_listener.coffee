class @SocketListener

  constructor: (socket) ->
    @socket = socket
    @init()

  init: ->
    @socket.emit "updateNickname",
      nickname : Nickname.get()

    @socket.on "confirmJoiningRoom", (data) =>

      roomName = data.roomName

      Rooms[roomName] = new Room(roomName)
      Tabs[roomName]  = new NavTab(roomName)

      Rooms[roomName].users.me.activateMyTextarea (diff, caretPos) =>
        @socket.emit "textUpdate",
          roomName : roomName
          diff     : diff
          caretPos : caretPos

      for data in data.clients
        Rooms[roomName].addUser(data)

    @socket.on "distributeTextUpdate", (data) ->
      Rooms[data.roomName].users[data.clientId].distributeText(data)

    @socket.on "announceNewClient", (data) ->
      Rooms[data.roomName].addUser(data)

    @socket.on "announceClientRemoval", (data) ->
      Rooms[data.roomName].removeUser(data.clientId)

    @socket.on "announceNicknameChange", (data) ->
      for roomName,room of Rooms
        subject = room.users[data.clientId]
        if subject
          subject.changeNickname(data.nickname)

    @socket.on "refuseJoiningRoom", (data) ->
      msg = "Couldnt join room ##{data.roomName}. Reason: "
      msg = if data.reason == "full"
        msg += "ROOM FULL"
      alert(msg)