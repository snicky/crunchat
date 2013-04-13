module.exports = (io, socket) ->

  require("../assets/js/server_and_client/js_helper")
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
        if client.id != socket.id && peers.indexOf(client.id) == -1
          peers.push(client.id)
    peers

  socket.findRandomRoom = ->
    rooms = []
    for roomNameWithSlash, roomClients of io.rooms
      # empty roomNameWithSlash string indicates a room that holds ALL clients
      if roomNameWithSlash
        roomName = roomNameWithSlash.substring(1)
        unless io.isRoomPrivate(roomName) or
          roomClients.length >= settings.clientsPerRoom or
          roomClients.indexOf(socket.id) > -1
            rooms.push(roomName)
    randomRoomName = JsHelper.arraySample(rooms)