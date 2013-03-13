module.exports = ->

  String.random = (length) ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789"
    
    i = 0
    while i < length
      text += possible.charAt(Math.floor(Math.random() * possible.length))
      i++
    
    text