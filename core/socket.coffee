module.exports = (io, socket) ->

  jsHelper = require("../assets/js/server_and_client/js_helper")
  settings = require("./settings")()

  require("./socket_helper")(io, socket)

  socket.clientId = socket.getClientId()

  socket.on "updateNickname", (data) ->
    socket.nickname = data.nickname

    for socketId in socket.getPeersIds()
      io.findSocket(socketId).emit "announceNicknameChange",
        clientId : socket.clientId
        nickname : socket.nickname

  socket.doJoinRoom = (roomName) ->
    clients = for client in io.clientsInRoom(roomName)
      { clientId : client.clientId, nickname : client.nickname }
    if clients.length < settings.clientsPerRoom
      if clients.length == 0
        socket.becomeRoomOp(roomName)
        isOp = true
      socket.join(roomName)
      confirmJoiningRoomHash = 
        roomName    : roomName
        clients     : clients
        roomPrivate : (isOp && socket.defaultRoomPrivacy) || io.isRoomPrivate(roomName)
      # declared only if isOp is true
      # we dont want to send anything if it's false
      confirmJoiningRoomHash.isOp = true if isOp
      socket.emit "confirmJoiningRoom", confirmJoiningRoomHash
      socket.broadcast.to(roomName).emit "announceNewClient",
        roomName : roomName
        clientId : socket.clientId
        nickname : socket.nickname
    else
      socket.emit "refuseJoiningRoom",
        reason   : "full"
        roomName : roomName

  socket.on "joinRoom", (data) ->
    roomName = data.roomName if data
    # delete next line?
    roomName = jsHelper.randomString(settings.idLength) unless roomName
    socket.doJoinRoom(roomName)

  socket.on "joinRandomRoom", (data) ->
    randomRoomName = socket.findRandomRoom()
    if randomRoomName
      socket.doJoinRoom(randomRoomName)
    else
      socket.emit "refuseJoiningRoom",
        reason : "noRooms"

  socket.on "leaveRoom", (data) ->
    roomName = data.roomName
    socket.leave(roomName)
    if io.clientsInRoom(roomName).length == 0
      socket.releaseRoomOp(roomName)
    else
      io.sockets.in(roomName).emit 'announceClientRemoval',
        roomName : roomName
        clientId : socket.clientId

      newOp = io.clientsInRoom(roomName)[0]
      newOp.becomeRoomOp(roomName)
      newOp.emit 'changeToOp',
        roomName : roomName

  socket.on "disconnect", ->
    for roomName in socket.getRooms()
      socket.broadcast.to(roomName).emit "announceClientRemoval",
        roomName : roomName
        clientId : socket.clientId

  socket.on "textUpdate", (data) ->
    socket.broadcast.to(data.roomName).emit 'distributeTextUpdate',
      roomName : data.roomName
      clientId : socket.clientId
      nickname : socket.nickname
      diff     : data.diff
      caretPos : data.caretPos

  socket.on "toggleRoomPrivacy", (data) ->
    if socket.isRoomOp(data.roomName)
      if data.boolSwitch
        io.makeRoomPrivate(data.roomName)
        socket.defaultRoomPrivacy = true
      else
        io.makeRoomPublic(data.roomName)
        socket.defaultRoomPrivacy = false

      socket.broadcast.to(data.roomName).emit "confirmToggleRoomPrivacy",
        roomName   : data.roomName
        boolSwitch : data.boolSwitch