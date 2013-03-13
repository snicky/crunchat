class @DiffCoder

  encode: (o, n) ->
    diff = (new diff_match_patch()).diff_main(o, n)

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