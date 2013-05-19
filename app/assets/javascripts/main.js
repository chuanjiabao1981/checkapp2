showXchart = function(y_num,data,position)
{
  var leftOffset, opts, topOffset, tt;
  tt = document.createElement("div");
  leftOffset = -($("html").css("padding-left").replace("px", "") + $("body").css("margin-left").replace("px", ""));
  topOffset = -32;
  tt.className = "ex-tooltip";
  document.body.appendChild(tt);
  opts = {
    paddingLeft: 30,
    paddingRight: 10,
    axisPaddingTop: 5,
    axisPaddingLeft: 5,
    tickHintY: y_num + 1,
    dataFormatX: function(x) {
      return d3.time.format("%Y-%m-%d").parse(x);
    },
    tickFormatX: function(x) {
      return d3.time.format("%a")(x);
    },
    mouseover: function(d, i) {
      var pos;
      pos = $(this).offset();
      return $(tt).text(d3.time.format("%Y-%m-%d")(d.x) + ": " + d.y).css({
        top: topOffset + pos.top,
        left: pos.left + leftOffset
      }).show();
    },
    mouseout: function(x) {
      return $(tt).hide();
    }
  };
  return new xChart("line-dotted", data, position, opts);
}

$(function() {
  if ($("#xcharts-line-dotted").length > 0) {
    showXchart(
      $("div#xcharts-data").data("y-distinct-value-num"),
      $("div#xcharts-data").data("xcharts-data"), 
      "#xcharts-line-dotted");
  }
  if ($("#xcharts-line-dotted-of-template-check-records").length > 0)
  {
    showXchart(
              $("div#xcharts-data-of-template-check-records").data("y-distinct-value-num"),
              $("div#xcharts-data-of-template-check-records").data("xcharts-data"),
              "#xcharts-line-dotted-of-template-check-records"
    ) 
  }
});


