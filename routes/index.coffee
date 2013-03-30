exports.index = (req, res) ->
  title = "Crunchat.com"
  if req.params.roomName
    title = req.params.roomName + " - " + title
  res.render 'index', { layout : "layout", title : title }