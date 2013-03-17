initialize = ->
  socket         = io.connect("http://localhost:3000")
  window.Rooms   = {}
  window.Tabs    = {}
  eventListener  = new EventListener(socket)
  socketListener = new SocketListener(socket)

$(initialize)


###
    $(window).unload ->
      socket.emit "leaveRoom",
        roomName : roomName
###