class @User

  @userSpaceTemplateKey = "userSpace"
  @diffCoder            = new DiffCoder()
  @storage              = new SNStorage()
  @storagePrefix        = "text:"

  constructor: (attrs) ->
    @myBoxClass = "my"

    @roomName   = attrs.roomName
    @userID     = attrs.userID
    @nickname   = attrs.nickname
    @storageKey = @storagePrefix + @roomName if @userID == "me"
    @putInDom()

  putInDom: ->
    @$dom = $(Templates[User.userSpaceTemplateKey])
    @$dom.attr("id", @getDomID())
    @$personalInfo = @$dom.find(".personal-info:first")
    @$personalInfo.text(@nickname + ":")
    @$textarea = @$dom.find("textarea:first")

    if @userID == "me"
      @$dom.addClass(@myBoxClass)
    else
      @$dom.find("textarea:first").attr
        disabled : 1

  getDomID: ->
    @roomName + "-" + @userID

  distributeText: (data) ->
    newText = User.diffCoder.decode(@$textarea.text(), data.diff)
    @$textarea.text(newText)
    @$textarea.scrollToCaret(data.caretPos) unless @$textarea.is(":focus")

  # distribute other users's nickname!
  changeNickname: (nickname) ->
    @$personalInfo.text("#{nickname}:")

  activateMyTextarea: (callback) ->
    User.storage.setItem(@storageKey, @$textarea.val())
    @$textarea.on "keyup", =>
      currentText = @$textarea.val()
      storedText  = User.storage.getItem(@storageKey)
      unless currentText is storedText
        diff = User.diffCoder.encode(storedText, currentText)
        User.storage.setItem(@storageKey, currentText)
        caretPos = @$textarea[0].selectionStart
        callback(diff, caretPos)