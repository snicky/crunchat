class @TitleChanger

  constructor: ->
    @isBlinking = false
    @blinkPhase = 0

  startBlinking: (roomName, nickname) ->
    unless @isBlinking
      @isBlinking = true
      @interval = setInterval (=>
        if @blinkPhase == 0
          @setBlinkTitle(roomName, nickname)
          @blinkPhase = 1
        else
          @refreshTitle()
          @blinkPhase = 0
      ), 1500

  stopBlinking: ->
    @isBlinking = false
    clearInterval(@interval)
    @blinkPhase = 0
    @refreshTitle()

  refreshTitle: (noRoomName) ->
    title = if noRoomName
      Common.settings.basicTitle      
    else
      roomName = NavTab.findActiveRoomName()
      unless roomName
        Common.settings.basicTitle
      else
        "##{NavTab.findActiveRoomName()} - #{Common.settings.basicTitle}"
    Common.DOM.title.text(title)

  setBlinkTitle: (roomName, nickname) ->
    Common.DOM.title.text("#{nickname} is writing to you in room ##{roomName}")