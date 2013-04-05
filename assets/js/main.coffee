initialize = ->
  socket         = io.connect(window.location.origin)
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
