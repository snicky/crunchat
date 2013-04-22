class @YTMovie

  constructor: (id) ->

    if Movies[id]
      false

    else
      ($.get "https://gdata.youtube.com/feeds/api/videos/#{id}?v=2", ->
        
        @id = id
        @params =
          allowScriptAccess: "always"

        $dom = $(Templates.YTMovie)
        $dom.find("div").attr("id",@id)

        if Common.DOM.ytContainer.hasClass("hidden")
          Common.DOM.ytContainer.removeClass("hidden")

        Common.DOM.ytSpace.prepend($dom)

        swfobject.embedSWF("http://www.youtube.com/v/#{@id}?enablejsapi=1&playerapiid=ytplayer&version=3",
        @id, "425", "356", "8", null, null, @params, { id: @id })

        @$dom = $("##{@id}")

        Movies[@id] = @

      ).fail ->
        # do sth on fail