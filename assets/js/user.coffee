class @User

  constructor: (attrs) ->
    @roomName       = attrs.roomName
    @userID         = attrs.userID
    @nickname       = attrs.nickname
    @textStorageKey = Common.settings.textStoragePrefix + @roomName if @userID == "me"
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

  # distribute other users's nickname!
  changeNickname: (nickname) ->
    @$personalInfo.text("#{nickname}:")

  activateMyTextarea: (callback) ->
    Common.storage.setItem(@textStorageKey, @$textarea.val())
    @$textarea.on "keyup", =>
      currentText = @$textarea.val()
      storedText  = Common.storage.getItem(@textStorageKey)
      unless currentText is storedText
        diff = Common.diffCoder.encode(storedText, currentText)
        Common.storage.setItem(@textStorageKey, currentText)
        caretPos = @$textarea[0].selectionStart
        callback(diff, caretPos)