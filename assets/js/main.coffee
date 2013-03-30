initialize = ->
  socket         = io.connect("http://web1.tunnlr.com:11630")
  window.Rooms   = {}
  window.Tabs    = {}
  Nickname.init()
  eventListener  = new EventListener(socket)
  socketListener = new SocketListener(socket)

$(initialize)


###
    $(window).unload ->
      socket.emit "leaveRoom",
        roomName : roomName
###
