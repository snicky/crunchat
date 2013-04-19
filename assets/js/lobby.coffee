class @Lobby

  @setLobbyInfo = (msg) ->
    info = Common.DOM.lobbyInfo
    info.text(msg)
    setTimeout (=>
      info.fadeOut 1000, =>
        info.text("")
        info.show()
        @showJoinForm()
    ), 3000

  @show = ->
    Common.DOM.lobby.show()

  @hide = ->
    Common.DOM.lobby.hide()

  @showJoinForm = ->
    Common.DOM.joinForm.show()

  @activate: ->
    NavTab.clearAll()
    Common.DOM.lobbyNavTab.addClass("active")
    @show()
    history.pushState(null, null, "/")
    Common.titleChanger.refreshTitle()