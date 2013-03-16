class @Nickname
  
  @permStorage      = new SNStorage("perm")
  @anonymousIdRange = [10000, 99999]
  @nicknameInputId  = "nickname"
  @maxStringLength  = 32

  @init: ->
    nickname = @get()
    unless nickname
      nickname = @random()
      @set(nickname)
    $("##{@nicknameInputId}").val(nickname)    

  @get: ->
    Nickname.permStorage.getItem("nickname")

  @set: (nickname) ->
    @permStorage.setItem("nickname", nickname)

  @random: ->
    "Anonymous" + Math.random_between(@anonymousIdRange[0], @anonymousIdRange[1])

  @change: ->
    previous = @get()
    nickname = $("##{@nicknameInputId}").val()
    changing = nickname != previous
    changing = false if nickname.length > @maxStringLength
    if nickname != previous && nickname.length <= @maxStringLength
      nickname = @randomNickname() unless nickname
      @set(nickname)
      $(".my").find(".personal-info:first").text("#{nickname}:")
      nickname
    else
      false
