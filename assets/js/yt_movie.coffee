class @YTMovie

  constructor: (id, room) ->

    if Movies[id]
      false

    else
      ($.get "https://gdata.youtube.com/feeds/api/videos/#{id}?v=2", ->
        
        @id   = id
        @room = room
        @params =
          allowScriptAccess: "always"

        @room.addYTBox(@id)

        swfobject.embedSWF("http://www.youtube.com/v/#{@id}?enablejsapi=1&playerapiid=ytplayer&version=3",
        @id, "425", "356", "8", null, null, @params, { id: @id })

        @room.hasYT = true

        @$dom = $("##{@id}")

        Movies[@id] = @

      ).fail ->
        # do sth on fail