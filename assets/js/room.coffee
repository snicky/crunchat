class @Room

  constructor: (name) ->
    @name  = name
    @users = {}
    @domID = Common.settings.roomIdPrefix + @name

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

  scaleBoxes: ->
    clean = =>
      boxes
        .removeClass(Common.classes.fullBox)
        .removeClass(Common.classes.firstHalfBox)
        .removeClass(Common.classes.secondHalfBox)

    boxes = @$dom.find(".#{Common.classes.userSpace}")
    if boxes.length < 3
      clean()
      boxes.addClass("full")
    else if boxes.length == 3
      clean()
      boxes.eq(0).addClass("full")
      boxes.eq(1).addClass(Common.classes.firstHalfBox)
      boxes.eq(2).addClass(Common.classes.secondHalfBox)
    else
      clean()
      boxes.eq(0).add(boxes.eq(2)).addClass(Common.classes.firstHalfBox)
      boxes.eq(1).add(boxes.eq(3)).addClass(Common.classes.secondHalfBox)

  removeUser: (userID) ->
    @users[userID].$dom.remove()
    delete @users[userID]
    @scaleBoxes()

  leave: ->
    # need to clean up all the variables?
    @$dom.remove()
    delete Rooms[@name]

  becomeOp: ->
    @$roomPrivacyCheckbox.attr("disabled",false)

  tickRoomPrivacyCheckBox: (boolSwitch) ->
    @$roomPrivacyCheckbox.prop("checked",boolSwitch)