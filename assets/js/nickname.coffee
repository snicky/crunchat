class @Nickname
  
  @init: ->
    nickname = @get()
    unless nickname
      nickname = @random()
      @set(nickname)
    Common.DOM.nicknameInput.val(nickname)    

  @get: ->
    Common.permStorage.getItem("nickname")

  @set: (nickname) ->
    Common.permStorage.setItem("nickname", nickname)

  @random: ->
    "Anonymous" + Math.random_between(Common.settings.anonymousIdRange[0], Common.settings.anonymousIdRange[1])

  @change: ->
    previous = @get()
    nickname = Common.DOM.nicknameInput.val()
    if nickname != previous && nickname.length <= Common.settings.maxStringLength
      nickname = @randomNickname() unless nickname
      @set(nickname)
      $(".my").find(".personal-info:first").text("#{nickname}:")
      nickname
    else
      false
