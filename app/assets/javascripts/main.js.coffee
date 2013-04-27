$ ->
  tt = document.createElement("div")
  leftOffset = -($("html").css("padding-left").replace("px", "") + $("body").css("margin-left").replace("px", ""))
  topOffset = -32
  tt.className = "ex-tooltip"
  document.body.appendChild tt
  opts =
    paddingLeft: 30
    paddingRight: 10
    axisPaddingTop: 5
    axisPaddingLeft: 5
    tickHintY: $("div#xcharts-data").data("y-distinct-value-num") + 1 
    dataFormatX: (x) ->
      d3.time.format("%Y-%m-%d").parse x

    tickFormatX: (x) ->
      d3.time.format("%a") x

    mouseover: (d, i) ->
      pos = $(this).offset()
      $(tt).text(d3.time.format("%Y-%m-%d")(d.x) + ": " + d.y).css(
        top: topOffset + pos.top
        left: pos.left + leftOffset
      ).show()

    mouseout: (x) ->
      $(tt).hide()

  if $(".xcharts-line-dotted").length > 0
    new xChart("line-dotted", $("div#xcharts-data").data("xcharts-data"), ".xcharts-line-dotted", opts)
