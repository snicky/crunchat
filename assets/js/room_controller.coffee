class @RoomController

  constructor: ->
    @rooms                  = []
    @mainSpaceId            = "main-space"
    @roomSpaceTemplate      = "room-space-template"
    @roomNameAttr           = "data-room-name"
    @roomIdPrefix           = "room-"
    @chatBoxIdPrefix        = "chat-box-"
    @myBoxClass             = "my"
    @fullBoxClass           = "full"
    @halfBoxClass           = "half"
    @firstHalfBoxClass      = "first-half"
    @secondHalfBoxClass     = "second-half"
    @chatBoxClass           = "chat-box"
    @chatBoxTemplateId      = "chat-box-template"
    @diffCoder              = new DiffCoder()
    @storage                = new SNStorage()
    @permStorage            = new SNStorage("perm")
    @storagePrefix          = "text:"

  for: (roomName) ->
    @roomName   = roomName
    @roomId     = @roomIdPrefix  + @roomName
    @storageKey = @storagePrefix + @roomName
    @
    
  addRoomSpace: ->
    template = $($("##{@roomSpaceTemplate}").html().trim()).clone()
    template.attr("id",@roomId)
    $("##{@mainSpaceId}").append(template)

  activate: (callback) ->
    @rooms.push(@roomName)
    @addRoomSpace()
    myBox = @addMyBox()
    @storage.setItem(@storageKey, myBox.val())
    myBox.on "keyup", =>
      currentText = myBox.find("textarea").val()
      storedText  = @storage.getItem(@storageKey)
      unless currentText is storedText
        diff = @diffCoder.encode(storedText, currentText)
        @storage.setItem(@storageKey, currentText)
        caretPos = myBox[0].selectionStart
        callback(diff, caretPos)

  addMyBox: ->
    template = $($("##{@chatBoxTemplateId}").html().trim()).clone()
    personalInfo = template.find(".personal-info")
    personalInfo.text(@permStorage.getItem("nickname") + ":")
    template.addClass(@myBoxClass).addClass(@fullBoxClass)
    $("##{@roomId} .clearfix").before(template)
    @scaleBoxes()
    return template

  addBox: (data) ->
    template = $($("##{@chatBoxTemplateId}").html().trim()).clone()
    template.attr("id", @chatBoxIdPrefix + data.clientId)
    personalInfo = template.find(".personal-info")
    personalInfo.text("#{data.nickname}:")
    template.find("textarea").attr("disabled",1)
    $("##{@roomId} .clearfix").before(template)
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
    $("##{@roomId} ##{@chatBoxIdPrefix}#{clientId}").remove()
    @scaleBoxes()

  removeRoomSpace: ->
    $("##{@roomId}").remove()

  leaveRoom: ->
    @removeRoomSpace()
    roomIndex = @rooms.indexOf(@roomName)
    @rooms.splice(roomIndex, 1)
    
  distributeText: (data) ->
    ta = $("##{@roomId} ##{@chatBoxIdPrefix}#{data.clientId} textarea")
    newText = @diffCoder.decode(ta.text(), data.diff)
    ta.text(newText)
    ta.scrollToCaret(data.caretPos) unless ta.is(":focus")

  # distribute other client's nickname!
  distributeNickname: (data) ->
    chatBox = $("##{@chatBoxIdPrefix}#{data.clientId}")
    chatBox.find(".personal-info").text("#{data.nickname}:")