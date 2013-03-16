settings =
  clientsPerRoom : 4
  idLength       : 5

# Requirements
express    = require("express")
partials   = require('express-partials')
socketIo   = require('socket.io')
http       = require("http")
path       = require("path")
_          = require("underscore")
routes     = require("./routes")
user       = require("./routes/user")

# Extensions
require("./ext/core")()
ext = require("./ext/custom")(settings)

# Express settings
app = express()
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "ejs"
  app.use partials()
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser("your secret here")
  app.use express.session()
  app.use app.router
  app.use require('connect-assets')()
  app.use express.static(path.join(__dirname, "public"))
  

app.configure "development", ->
  app.use express.errorHandler()

# Routes
app.get "/"           , routes.index
app.get "/2"           , routes.index2
app.get "/_:roomName" , routes.index

# Init
server = http.createServer(app)
io     = socketIo.listen(server)

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

# Websockets
io.sockets.on "connection", (socket) ->

  socket.clientId = ext.parseClientId(socket)

  socket.getRooms = ->
    # room names from manager.roomClients contain "/" slash as the first char
    (k.substring(1) for k,v of io.sockets.manager.roomClients[socket.id] when k)

  socket.getPeersIds = ->
    peers = []
    for roomName in socket.getRooms()
      for client in io.sockets.clients(roomName)
        peers.push(client.id) if client.id != socket.id && peers.indexOf(client.id) == -1
    peers

  socket.on "updateNickname", (data) ->
    socket.nickname = data.nickname

    for socketId in socket.getPeersIds()
      io.sockets.sockets[socketId].emit "announceNicknameChange",
        clientId : socket.clientId
        nickname : socket.nickname

  socket.doJoinRoom = (roomName) ->
    clients = for client in io.sockets.clients(roomName)
      { clientId : ext.parseClientId(client) , nickname : client.nickname }
    if clients.length < settings.clientsPerRoom
      socket.join(roomName)
      socket.emit "confirmJoiningRoom",
        roomName : roomName
        clients  : clients
      socket.broadcast.to(roomName).emit "announceNewClient",
        roomName : roomName
        clientId : socket.clientId
        nickname : socket.nickname
    else
      socket.emit "refuseJoiningRoom",
        reason   : "full"
        roomName : roomName

  socket.on "joinRoom", (data) ->
    roomName = data.roomName if data
    # delete next line?
    roomName = String.random(settings.idLength) unless roomName
    socket.doJoinRoom(roomName)

  socket.on "joinRandomRoom", (data) ->
    rooms = []
    for k,v of io.sockets.manager.rooms
      if k
        if !(v.length >= settings.clientsPerRoom) and v.indexOf(socket.id) == -1
          rooms.push(k.substring(1))
    randomRoomName = rooms[Math.floor(Math.random() * rooms.length)]
    if randomRoomName
      socket.doJoinRoom(randomRoomName)
    else
      # do sth

  socket.on "leaveRoom", (data) ->
    socket.leave(data.roomName)
    io.sockets.in(data.roomName).emit 'announceClientRemoval',
      roomName : data.roomName
      clientId : socket.clientId

  socket.on "disconnect", ->
    for roomName in socket.getRooms()
      socket.broadcast.to(roomName).emit "announceClientRemoval",
        roomName : roomName
        clientId : socket.clientId

  socket.on "textUpdate", (data) ->
    socket.broadcast.to(data.roomName).emit 'distributeTextUpdate',
      roomName : data.roomName
      clientId : socket.clientId
      diff     : data.diff
      caretPos : data.caretPos



###
  socket.findPartners = ->
    clientRooms = socket.getRooms()
    # io.sockets.manager.roomClients returns room name with "/" slash
    # as the first character
    usersInRooms = (io.sockets.clients(room.substring(1)) for room in clientRooms)
    usersInRooms = _.uniq(_.flatten(usersInRooms))
    # remove self
    usersInRooms = (user for user in usersInRooms when user.id != socket.id)
###