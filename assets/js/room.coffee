class @Room

  constructor: (name) ->
    @name  = name
    @users = {}
    @domID = Settings.roomIdPrefix + @name

    @$dom = $(Templates.Room)
    @$dom.attr("id",@domID)
    @$closeBtn = @$dom.find(".btn-close:first")
    @$closeBtn.attr(Settings.roomNameAttr,@name)
    @$clearfix = @$dom.find(".clearfix:first")
    $("##{Settings.ids.mainSpace}").append(@$dom)
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
      boxes.removeClass(Settings.classes.fullBox).removeClass(Settings.classes.firstHalfBox).removeClass(Settings.classes.secondHalfBox)

    boxes = @$dom.find(".#{Settings.classes.userSpace}")
    if boxes.length < 3
      clean()
      boxes.addClass("full")
    else if boxes.length == 3
      clean()
      boxes.eq(0).addClass("full")
      boxes.eq(1).addClass(Settings.classes.firstHalfBox)
      boxes.eq(2).addClass(Settings.classes.secondHalfBox)
    else
      clean()
      boxes.eq(0).add(boxes.eq(2)).addClass(Settings.classes.firstHalfBox)
      boxes.eq(1).add(boxes.eq(3)).addClass(Settings.classes.secondHalfBox)

  removeUser: (userID) ->
    @users[userID].$dom.remove()
    delete @users[userID]
    @scaleBoxes()

  leave: ->
    # need to clean up all the variables?
    @$dom.remove()
    delete Rooms[@name]