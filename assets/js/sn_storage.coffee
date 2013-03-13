class @SNStorage

  constructor: (reqType) ->
    if reqType == "perm" && window.localStorage
      @storage = window.localStorage
      @type    = "local"
    else if window.sessionStorage
      @storage = window.sessionStorage
      @type    = "session"
    else
      @storage = {}
      @type    = "variable"

  useDedicatedStorage: ->
    @type == "local" or @type == "session"

  setItem: (key, value) ->
    if key
      if @useDedicatedStorage()
        value = if value == "" then value else JSON.stringify(value)
        @storage.setItem(key, value)
      else
        @storage[key] = value

  getItem: (key) ->
    if key
      if @useDedicatedStorage()
        value = @storage.getItem(key)
        if value == "" then value else JSON.parse(value)
      else
        @storage[key]

  removeItem: (key) ->
    if key
      if @useDedicatedStorage()
        @storage.removeItem(key)
      else
        delete @storage[key]