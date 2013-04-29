window.acceleration = 0

scroll = ->
  $('#video-thumbs').css 'left', (index, curValue) ->
    "#{parseInt(curValue) + window.acceleration}px"

setInterval(scroll, 20)

jQuery ->

  $(document).bind 'cbox_complete', ->
    # _V_("video").ready ->
    #   this.play()

  $('a[data-popup]').colorbox
    initialWidth: 326
    width: 360
    height: 350

  $('ul#video-thumbs a').colorbox
    initialWidth: 326
    width: 810
    height: 460

  $(window).resize ->
    $('.text').html 'a'

  $(document).mousemove (e) ->
    if (e.pageX > $('body').width() - 50)
      window.acceleration = -3
    else if (e.pageX < 50)
      window.acceleration = 3
    else
      window.acceleration = 0
