((exports) ->
  
  exports.randomString = (length) ->
    text = ""
    possible = "abcdefghijklmnopqrstuvwxyz0123456789"
    
    i = 0
    while i < length
      text += possible.charAt(Math.floor(Math.random() * possible.length))
      i++
    
    text

  exports.arraySample = (arr) ->
    arr[Math.floor(Math.random() * arr.length)]

  exports.randomBetween = (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

) (if typeof exports is "undefined" then this["JsHelper"] = {} else exports)