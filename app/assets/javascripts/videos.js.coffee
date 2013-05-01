window.acceleration = 0
window.active = null
window.activeIndex = null
window.positions = []

map = (x, in_min, in_max, out_min, out_max) ->
  (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

scroll = ->
  if (window.acceleration != 0)
    currentPosition = parseInt $('#video-thumbs').css('left')
    newPosition = currentPosition + window.acceleration
    minLeft = $(window).width()/2 - $('.thumb').width()/2
    maxLeft = $(window).width()/2 - $('#video-thumbs').width() + $('.thumb').width()/2

    newPosition = parseInt Math.max( maxLeft, Math.min( minLeft, newPosition))
    $('#video-thumbs').css 'left', -> "#{newPosition}px"
    checkActive()

reset = ->
  window.acceleration = 0
  position = parseInt $('#video-thumbs').css('left')
  minLeft = $(window).width()/2 - $('.thumb').width()/2
  TweenLite.to($('#video-thumbs'), 0.5, {left: window.active})
  # minLeft - $('.thumb').width() * window.active

checkActive = ->
  goal = parseInt $('#video-thumbs').css('left')
  closest = null
  closestIndex = null
  $.each window.positions, (index, value) ->
    if (closest == null || Math.abs(value - goal) < Math.abs(closest - goal))
      closest = value
      closestIndex = index

  window.active = closest

  activeThumb = $(".thumb:eq(#{closestIndex}) a:first-child")
  console.log activeThumb
  $('span.kind').text( "#{activeThumb.data('kind')}:" )
  $('span.name').text( activeThumb.data('name') )
  $('span.client_name').text( activeThumb.data('client') )


setInterval(scroll, 10)

jQuery ->

  $(window).resize( ->
    # window.positions = x for x in [minLeft..maxLeft] by -315
    minLeft = $(window).width()/2 - $('.thumb').width()/2
    maxLeft = $(window).width()/2 - $('#video-thumbs').width() + $('.thumb').width()/2 - $('.thumb').width()
    window.positions = _.range(minLeft, maxLeft, -315)
    console.log window.positions
    checkActive()

    reset()
  ).trigger 'resize'

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

  $('.holder').mousemove (e) ->
    TweenLite.killTweensOf($('#video-thumbs'))
    maxSpeed = 10
    xPos = e.pageX
    width = $('.left').width() * .65
    if (xPos > $('body').width() - width)
      window.acceleration = map(xPos, $('body').width() - width, $('body').width(), 0, -maxSpeed)
    else if (e.pageX < width)
      window.acceleration = map(xPos, 0, width, maxSpeed, 0)
    else reset()

  $('.holder').mouseout (e) -> reset()
