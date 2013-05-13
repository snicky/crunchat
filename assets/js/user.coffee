class @User

  constructor: (attrs) ->
    @roomName = attrs.roomName
    @userID   = attrs.userID
    @nickname = attrs.nickname
    @putInDom()

  putInDom: ->
    @$dom = $(Templates.User)
    @$dom.attr("id", @getDomID())
    @$personalInfo = @$dom.find(".personal-info:first")
    @$personalInfo.text(@nickname + ":")
    @$textarea = @$dom.find("textarea:first")

    if @userID == "me"
      @$dom.addClass(Common.classes.myBox)
    else
      @$dom.find("textarea:first").attr
        disabled : 1

  getDomID: ->
    @roomName + "-" + @userID

  distributeText: (data) ->
    newText = Common.diffCoder.decode(@$textarea.text(), data.diff)
    @$textarea.text(newText)
    @$textarea.scrollToCaret(data.caretPos) unless @$textarea.is(":focus")
    Rooms[data.roomName].addYoutubeMovie(data.diff)

  # distribute other users's nickname!
  changeNickname: (nickname) ->
    @$personalInfo.text("#{nickname}:")

  focusOnTextarea: ->
    @$textarea.focus()