class @ChatController

  @maxStringLength  = 32

  constructor: (socket) ->
    @socket = socket

  joinRoom: (roomName) ->
    if roomName.length < ChatController.maxStringLength && !Rooms[roomName]
      @socket.emit "joinRoom", 
        roomName : roomName