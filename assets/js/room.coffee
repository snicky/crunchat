class @Room

  constructor: (name) ->
    @mainSpaceId          = "main-space"
    @roomSpaceTemplateKey   = "roomSpace"
    @roomIdPrefix         = "room-"
    @fullBoxClass         = "full"
    @halfBoxClass         = "half"
    @firstHalfBoxClass    = "first-half"
    @secondHalfBoxClass   = "second-half"
    @userSpaceClass       = "user-space"
    @roomNameAttr         = "data-room-name"


    @permStorage          = new SNStorage("perm")

    @name  = name
    @users = {}
    @domID = @roomIdPrefix + @name

    @$dom = $(Templates[@roomSpaceTemplateKey])
    @$dom.attr("id",@domID)
    @$closeBtn = @$dom.find(".btn-close:first")
    @$closeBtn.attr(@roomNameAttr,@name)
    @$clearfix = @$dom.find(".clearfix:first")
    $("##{@mainSpaceId}").append(@$dom)
    @addMe()

  addMe: ->
    @users.me = new User
      roomName : @name
      userID   : "me"
      nickname : @permStorage.getItem("nickname")
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
      boxes.removeClass(@fullBoxClass).removeClass(@firstHalfBoxClass).removeClass(@secondHalfBoxClass)

    boxes = @$dom.find(".#{@userSpaceClass}")
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

  removeUser: (userID) ->
    @users[userID].$dom.remove()
    delete @users[userID]
    @scaleBoxes()

  leave: ->
    # need to clean up all the variables?
    @$dom.remove()
    delete Rooms[@name]