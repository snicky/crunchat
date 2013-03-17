class @Nickname
  
  @init: ->
    nickname = @get()
    unless nickname
      nickname = @random()
      @set(nickname)
    $("##{Settings.ids.nicknameInput}").val(nickname)    

  @get: ->
    Common.permStorage.getItem("nickname")

  @set: (nickname) ->
    Common.permStorage.setItem("nickname", nickname)

  @random: ->
    "Anonymous" + Math.random_between(Settings.anonymousIdRange[0], Settings.anonymousIdRange[1])

  @change: ->
    previous = @get()
    nickname = $("##{Settings.ids.nicknameInput}").val()
    if nickname != previous && nickname.length <= Settings.maxStringLength
      nickname = @randomNickname() unless nickname
      @set(nickname)
      $(".my").find(".personal-info:first").text("#{nickname}:")
      nickname
    else
      false
