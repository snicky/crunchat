initialize = ->
  socket         = io.connect("http://localhost:8080")
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
