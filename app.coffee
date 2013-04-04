# Requirements
express    = require("express")
partials   = require('express-partials')
socketIo   = require('socket.io')
http       = require("http")
path       = require("path")
_          = require("underscore")
routes     = require("./routes")
user       = require("./routes/user")

# Express settings
app = express()
app.configure ->
  app.set "port", process.env.PORT or 8080
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
app.get "/_:roomName" , routes.index

# Init
server = http.createServer(app)
io     = socketIo.listen(server)

server.listen app.get("port"), ->
  console.log "Express #{app.get("env")} server listening on port #{app.get("port")}"

# Websockets
require("./core/io")(io)

io.sockets.on "connection", (socket) ->
  require("./core/socket")(io, socket)