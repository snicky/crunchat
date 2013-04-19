exports.index = (req, res) ->
  if req.params.roomName
    title = req.params.roomName + " - " + title
  res.render 'index', 
    layout            : "layout"
    soundSwitchCookie : req.cookies.sound
    title             : "Crunchat.com"
    userAgent         : req.headers['user-agent']