initialize = ->
  socket         = io.connect("http://localhost:3000")
  window.Rooms   = {}
  navController  = new NavController(socket)
  socketListener = new SocketListener(socket, navController)

$(initialize)


###
    $(window).unload ->
      socket.emit "leaveRoom",
        roomName : roomName
###