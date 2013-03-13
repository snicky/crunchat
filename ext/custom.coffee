module.exports = (settings) ->

  parseClientId: (socket) ->
    socket.id[0..settings.idLength-1]

  extend: (objectToExtend, objects...) ->
    for object in objects
      for key, value of object
        objectToExtend[key] = value
    return objectToExtend