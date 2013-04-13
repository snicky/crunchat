initialize = ->
  socket         = io.connect(window.location.origin)
  window.Rooms   = {}
  window.Tabs    = {}
  titleChanger   = new TitleChanger()
  eventListener  = new EventListener(socket, titleChanger)
  socketListener = new SocketListener(socket, titleChanger)

$(initialize)


###
    $(window).unload ->
      socket.emit "leaveRoom",
        roomName : roomName
###
