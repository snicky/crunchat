class @SoundPlayer

  constructor: ->
    @playing      = false
    @soundsAmount = 4
    @sounds       = for i in [0..@soundsAmount-1]
                      document.getElementById("crunch#{i}")

    for sound in @sounds
      sound.addEventListener "ended", =>
        @playing = false

  play: (i) ->
    console.log i
    unless @playing
      @playing = true
      @sounds[i].play()

  playRandom: ->
    @play(JsHelper.randomBetween(0, @soundsAmount-1))