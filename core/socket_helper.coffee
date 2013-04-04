module.exports = (io, socket) ->

  ext      = require("../extensions/custom")()
  settings = require("./settings")()

  socket.getClientId = ->
    this.id[0..settings.idLength-1]

  socket.isRoomOp = (roomName) ->
    io.roomOps[roomName] == socket.id

  socket.becomeRoomOp = (roomName) ->
    io.roomOps[roomName] = socket.id

  socket.releaseRoomOp = (roomName) ->
    delete io.roomOps[roomName]

  # get rooms of this socket
  socket.getRooms = ->
    # room names from manager.roomClients contain "/" slash as the first char
    (k.substring(1) for k,v of io.roomClients[socket.id] when k)

  # get peers from all the rooms of this socket
  socket.getPeersIds = ->
    peers = []
    for roomName in socket.getRooms()
      for client in io.clientsInRoom(roomName)
        peers.push(client.id) if client.id != socket.id && peers.indexOf(client.id) == -1
    peers

  socket.findRandomRoom = ->
    rooms = []
    for roomName, roomClients of io.rooms
      if roomName
        if !io.isRoomPrivate(roomName) and !(roomClients.length >= settings.clientsPerRoom) and roomClients.indexOf(socket.id) == -1
          rooms.push(roomName.substring(1))
    randomRoomName = ext.arraySample(rooms)