class @SoundPlayer

  constructor: (switchCookieKey) ->
    @switchCookieKey = switchCookieKey
    @on              = @getSwitchFromCookie()
    @playing         = false
    @soundsAmount    = 4
    @sounds          = for i in [0..@soundsAmount-1]
                         document.getElementById("crunch#{i}")

    for sound in @sounds
      sound.addEventListener "ended", =>
        @playing = false

  getSwitchFromCookie: ->
    switchCookie = $.cookie(@switchCookieKey)
    if switchCookie then JSON.parse(switchCookie) else true

  toggle: ->
    @on = !@getSwitchFromCookie()
    $.cookie(@switchCookieKey, @on)

  play: (i) ->
    if @on and !@playing
      @playing = true
      @sounds[i].play()

  playRandom: ->
    @play(JsHelper.randomBetween(0, @soundsAmount-1))