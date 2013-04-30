window.acceleration = 0


map = (x, in_min, in_max, out_min, out_max) ->
  (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

scroll = ->
  if (window.acceleration != 0)
    currentPosition = parseInt $('#video-thumbs').css('left')
    newPosition = currentPosition + window.acceleration
    minLeft = $(window).width()/2 - 315/2 + 1
    maxLeft = 315
    newPosition = parseInt Math.min( minLeft, newPosition)
    # newPosition = parseInt Math.max( maxLeft, newPosition)
    $('#video-thumbs').css 'left', -> "#{newPosition}px"

setInterval(scroll, 10)

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
    maxSpeed = 12
    xPos = e.pageX
    width = $('.left').width() * .65
    if (xPos > $('body').width() - width)
      window.acceleration = map(xPos, $('body').width() - width, $('body').width(), 0, -maxSpeed)
    else if (e.pageX < width)
      window.acceleration = map(xPos, 0, width, maxSpeed, 0)
    else
      window.acceleration = 0
