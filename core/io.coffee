module.exports = (io) ->

  io.privateRooms = []
  io.roomOps      = {}

  io.findSocket = (socketId) ->
    io.sockets.sockets[socketId]

  # io.clientsInRoom is not the same as io.sockets.in(roomName)
  # the first one is an array of sockets
  # the second one is an object that allows to emit messages to sockets in a room
  io.clientsInRoom = (roomName) ->
    io.sockets.clients(roomName)

  io.makeRoomPrivate = (roomName) ->
    io.privateRooms.push(roomName)

  io.makeRoomPublic = (roomName) ->
    index = io.privateRooms.indexOf(roomName)
    if index != -1
      io.privateRooms.splice(index,1)

  io.isRoomPrivate = (roomName) ->
    io.privateRooms.indexOf(roomName) > -1