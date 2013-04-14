class @DiffCoder

  constructor: ->
    @diffMatchPatch = new diff_match_patch()

  encode: (o, n) ->
    diff = @diffMatchPatch.diff_main(o, n)

    for item in diff
      if item[0] is 0 or item[0] is -1
        item[1] = item[1].length

    return diff

  decode: (o, diff) ->
    n = ""
    i = 0
    
    for item in diff
      if item[0] is 0
        n += o.slice(i, i+item[1])
      if item[0] is 0 or item[0] is -1
        i += item[1]
      else
        n += item[1]

    return n

  find: (type, diff) ->
    if type == "YT"
      ytRegexp = /.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=)([^#\&\?]*).*/
      for diffEl in diff
        if diffEl[0] == 1 && typeof diffEl[1] is "string"
          match = diffEl[1].match(ytRegexp)
          return match[1] if match