class @Nickname
  
  @init: ->
    nickname = @get()
    unless nickname
      nickname = @random()
      @set(nickname)
    Common.DOM.nicknameInput.val(nickname)
    nickname

  @get: ->
    Common.permStorage.getItem("nickname")

  @set: (nickname) ->
    Common.permStorage.setItem("nickname", nickname)

  @random: ->
    "Anonymous" + JsHelper.randomBetween(Common.settings.anonymousIdRange[0], Common.settings.anonymousIdRange[1])

  @change: ->
    previous = @get()
    nickname = Common.DOM.nicknameInput.val()
    if nickname.length > 0 &&
      nickname != previous &&
      nickname.length <= Common.settings.maxStringLength
        @set(nickname)
        $(".#{Common.classes.myBox}").find(".personal-info:first").text("#{nickname}:")
        nickname
    else
      false