class @RoomController

  constructor: ->
    @rooms                  = []
    @mainSpaceId            = "main-space"
    @roomNameAttr           = "data-room-name"
    @roomIdPrefix           = "room-"
    @chatBoxIdPrefix        = "chat-box-"
    @textareaIdPrefix       = "textarea-"
    @myBoxIdPrefix          = "my-"
    @myTextareaIdPrefix     = "my-textarea-"
    @fullBoxClass           = "full"
    @halfBoxClass           = "half"
    @firstHalfBoxClass      = "first-half"
    @secondHalfBoxClass     = "second-half"
    @chatBoxClass           = "chat-box"
    @roomSpaceTemplateKey   = "roomSpace"
    @chatBoxTemplateKey     = "chatBox"
    @diffCoder              = new DiffCoder()
    @storage                = new SNStorage()
    @permStorage            = new SNStorage("perm")
    @storagePrefix          = "text:"

  find: (roomName) ->
    @roomName   = roomName
    @roomId     = @roomIdPrefix     + @roomName
    @storageKey = @storagePrefix    + @roomName
    @

  getChatBoxId: (clientId) ->
    @chatBoxIdPrefix  + @roomName + "-" + clientId

  getTextareaId: (clientId) ->
    @textareaIdPrefix + @roomName + "-" + clientId

  getMyBoxId: ->
    @myBoxIdPrefix + @roomName

  getMyTextareaId: ->
    @myTextareaIdPrefix + @roomName
    
  addRoomSpace: ->
    template = $(Templates[@roomSpaceTemplateKey])
    template.attr("id",@roomId)
    $("##{@mainSpaceId}").append(template)

  activate: (callback) ->
    @rooms.push(@roomName)
    @addRoomSpace()
    myBox = @addMyBox()
    myTextarea = $("#"+@getMyTextareaId())
    @storage.setItem(@storageKey, myTextarea.val())
    myTextarea.on "keyup", =>
      currentText = myTextarea.val()
      storedText  = @storage.getItem(@storageKey)
      unless currentText is storedText
        diff = @diffCoder.encode(storedText, currentText)
        @storage.setItem(@storageKey, currentText)
        caretPos = myTextarea[0].selectionStart
        callback(diff, caretPos)

  addMyBox: ->
    template = $(Templates[@chatBoxTemplateKey])
    template.addClass(@fullBoxClass).attr("id",@getMyBoxId())
    template.find("textarea:first").attr("id",@getMyTextareaId())
    personalInfo = template.find(".personal-info:first")
    personalInfo.text(@permStorage.getItem("nickname") + ":")
    $("##{@roomId} .clearfix:first").before(template)
    @scaleBoxes()
    return template

  addBox: (data) ->
    template = $(Templates[@chatBoxTemplateKey])
    template.attr("id", @getChatBoxId(data.clientId))
    personalInfo = template.find(".personal-info:first")
    personalInfo.text("#{data.nickname}:")
    template.find("textarea:first").attr
      id       : @getTextareaId(data.clientId)
      disabled : 1
    $("##{@roomId} .clearfix:first").before(template)
    @scaleBoxes()
    return template

  scaleBoxes: ->
    clean = =>
      boxes.removeClass(@fullBoxClass).removeClass(@firstHalfBoxClass).removeClass(@secondHalfBoxClass)

    boxes = $("##{@roomId} .#{@chatBoxClass}")
    if boxes.length < 3
      clean()
      boxes.addClass("full")
    else if boxes.length == 3
      clean()
      boxes.eq(0).addClass("full")
      boxes.eq(1).addClass(@firstHalfBoxClass)
      boxes.eq(2).addClass(@secondHalfBoxClass)
    else
      clean()
      boxes.eq(0).add(boxes.eq(2)).addClass(@firstHalfBoxClass)
      boxes.eq(1).add(boxes.eq(3)).addClass(@secondHalfBoxClass)

  removeBox: (clientId) ->
    $("#"+@getChatBoxId(clientId)).remove()
    @scaleBoxes()

  removeRoomSpace: ->
    $("##{@roomId}").remove()

  leaveRoom: ->
    @removeRoomSpace()
    roomIndex = @rooms.indexOf(@roomName)
    @rooms.splice(roomIndex, 1)
    
  distributeText: (data) ->
    ta = $("#"+@getTextareaId(data.clientId))
    newText = @diffCoder.decode(ta.text(), data.diff)
    ta.text(newText)
    ta.scrollToCaret(data.caretPos) unless ta.is(":focus")

  # distribute other client's nickname!
  distributeNickname: (data) ->
    chatBox = $("#"+@getChatBoxId(data.clientId))
    chatBox.find(".personal-info:first").text("#{data.nickname}:")