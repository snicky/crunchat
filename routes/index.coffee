exports.index = (req, res) ->
  res.render 'index', { layout : "layout", title  : "Chatroom: #{req.params.roomName}" }

exports.index2 = (req, res) ->
  res.render 'index2', { title: "kupka"}

 exports.indexx = (req, res) ->
 	res.end('index')