class @Room

  constructor: (name) ->
    @name             = name
    @users            = {}
    @hasYT            = false
    @domID            = Common.settings.roomIdPrefix + @name
    @myTextStorageKey = Common.settings.textStoragePrefix + @roomName

    @$dom = $(Templates.Room)
    @$dom.attr("id",@domID)
    @$roomControl = @$dom.find(".#{Common.classes.roomControl}:first")
    @$roomControl.attr(Common.settings.roomNameAttr,@name)
    @$roomPrivacyCheckbox = @$roomControl.find(".#{Common.classes.roomPrivacyCheckbox}:first")
    @$closeBtn = @$roomControl.find(".#{Common.classes.closeButton}:first")
    @$clearfix = @$dom.find(".clearfix:first")
    Common.DOM.mainSpace.append(@$dom)
    @addMe()

  addMe: ->
    @users.me = new User
      roomName : @name
      userID   : "me"
      nickname : Common.permStorage.getItem("nickname")
    @$clearfix.before(@users.me.$dom)
    @scaleBoxes()

  addUser: (data) ->
    @users[data.clientId] = new User
      roomName : @name
      userID   : data.clientId
      nickname : data.nickname
    @$clearfix.before(@users[data.clientId].$dom)
    @scaleBoxes()

  activateMyTextarea: (callback) ->
    $textarea = @$dom.find("textarea:first")
    Common.storage.setItem(@myTextStorageKey, $textarea.val())
    $textarea.on "keyup", =>
      currentText = $textarea.val()
      storedText  = Common.storage.getItem(@myTextStorageKey)
      unless currentText is storedText
        diff = Common.diffCoder.encode(storedText, currentText)
        Common.storage.setItem(@myTextStorageKey, currentText)
        caretPos = $textarea[0].selectionStart
        callback(diff, caretPos)
        @addYoutubeMovie(diff)

  addYoutubeMovie: (diff) ->
    youtubeID = Common.diffCoder.find("YT", diff)
    new YTMovie(youtubeID, @name) if youtubeID

  scaleBoxes: ->
    boxes = @$dom.find(".#{Common.classes.userSpace}")
    boxes
        .removeClass(Common.classes.fullBox)
        .removeClass(Common.classes.firstHalfBox)
        .removeClass(Common.classes.secondHalfBox)

    if @hasYT
      @scaleBoxesWithYT(boxes)
    else
      @scaleBoxesWithoutYT(boxes)

  scaleBoxesWithoutYT: (boxes) ->
    if boxes.length < 3
      boxes.addClass("full")
    else if boxes.length == 3
      boxes.eq(0).addClass("full")
      boxes.eq(1).addClass(Common.classes.firstHalfBox)
      boxes.eq(2).addClass(Common.classes.secondHalfBox)
    else
      boxes.eq(0).add(boxes.eq(2)).addClass(Common.classes.firstHalfBox)
      boxes.eq(1).add(boxes.eq(3)).addClass(Common.classes.secondHalfBox)

  scaleBoxesWithYT: (boxes) ->
    if boxes.length <= 3
      first  = boxes.eq(0)
      second = boxes.eq(1)
      first.add(second).addClass("first-half")
      first.after($(Templates.Clearfix))
    else
      @scaleBoxesWithoutYT(boxes)

  addYTBox: (youtubeID) ->
    boxes = @$dom.find(".#{Common.classes.userSpace}")
    @scaleBoxesWithYT(boxes)

    ytBox = $(Templates.YTMovie)
    ytBox.find("div").attr("id",youtubeID)

    if boxes.length <= 3
      if boxes.length == 2
        ytBox.addClass("yt-box-medium")
      else
        ytBox.addClass("yt-box-small")
      boxes.eq(0).after(ytBox)
    else
      ytBox.addClass("yt-box-large")
      # boxes.eq(3) ???
      boxes.after(ytBox)

  removeUser: (userID) ->
    @users[userID].$dom.remove()
    delete @users[userID]
    @scaleBoxes()

  remove: ->
    # need to clean up all the variables?
    @$dom.remove()
    delete Rooms[@name]

  becomeOp: ->
    @$roomPrivacyCheckbox.attr("disabled",false)

  tickRoomPrivacyCheckBox: (boolSwitch) ->
    @$roomPrivacyCheckbox.prop("checked",boolSwitch)

  isVisible: ->
    @$dom.is(":visible")