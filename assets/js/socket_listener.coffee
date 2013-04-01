class @SocketListener

  constructor: (socket) ->
    @socket = socket
    @init()

  init: ->
    @socket.emit "updateNickname",
      nickname : Nickname.init()

    @socket.on "confirmJoiningRoom", (data) =>

      roomName = data.roomName

      Common.spinner.stop()

      Rooms[roomName] = new Room(roomName)
      Tabs[roomName]  = new NavTab(roomName)

      # joinForm is hidden after clicking "Join/Random"
      Lobby.showJoinForm()

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
      Common.spinner.stop()
      Lobby.show()
      if data.reason == "full"
        Lobby.setLobbyInfo("Room ##{data.roomName} is full :(")
      else if data.reason == "noRooms"
        Lobby.setLobbyInfo("There are no rooms to join now. Go ahead and create your own.")

    @socket.on "changeToOp", (data) ->
      Rooms[data.roomName].becomeOp()