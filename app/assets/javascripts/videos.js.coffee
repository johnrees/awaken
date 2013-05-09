window.acceleration = 0
window.active = null
window.activeIndex = null
window.positions = []

window.padding = 2 # padding + border-width

map = (x, in_min, in_max, out_min, out_max) ->
  (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

scroll = ->
  if (window.acceleration != 0)
    currentPosition = parseInt $('#video-thumbs').css('left')
    newPosition = currentPosition + window.acceleration
    minLeft = $(window).width()/2 - $('.thumb').width()/2 - window.padding
    maxLeft = $(window).width()/2 - $('#video-thumbs').width() + $('.thumb').width()/2 - window.padding

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

  window.active = closest - window.padding
  window.activeIndex = closestIndex

  activeThumb = $(".thumb:eq(#{closestIndex}) a:first-child")
  $('span.kind').text( "#{activeThumb.data('kind')}:" )
  $('span.name').text( activeThumb.data('name') )
  $('span.client_name').text( activeThumb.data('client') )

setInterval(scroll, 10)

init = ->

  $('#main .inner').fadeIn()

  $(document).bind 'cbox_closed', ->
    History.pushState(null, null, '/')

  $('.polaroid').click (e) ->
    e.preventDefault()
    current = $(".thumb:eq(#{window.activeIndex}) a:first-child")
    link = current.attr('href')
    name = current.data('name')
    location = link
    History.pushState(null, "#{name} | James Rouse", link)


  $(window).resize( ->
    # window.positions = x for x in [minLeft..maxLeft] by -315
    minLeft = $(window).width()/2 - $('.thumb').width()/2
    maxLeft = $(window).width()/2 - $('#video-thumbs').width() + $('.thumb').width()/2 - $('.thumb').width()
    window.positions = _.range(minLeft, maxLeft, -315)
    checkActive()

    reset()
  ).trigger 'resize'

  $('a[data-popup]').click (e) ->
    e.preventDefault()
    History.pushState(null, "#{$(this).text()} | James Rouse", $(this).attr('href'))

  # $('a[data-popup]').colorbox
  #   initialWidth: 326
  #   width: 360
  #   height: 350


  $('ul#video-thumbs a').click -> false

  # $('ul#video-thumbs a').colorbox
  #   initialWidth: 326
  #   width: 810
  #   height: 460

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

jQuery ->

  $('#main .inner').hide()

  # -- History Stuff

  History = window.History
  if History.enabled
    console.log 'history enabled'
    $('#main .inner').load '/videos', ->
      init()
  else
    console.log 'history NOT enabled'
    return false

  $(window).bind 'statechange', ->
    console.log 'received statechange'
    State = History.getState()

    # if $('.modal').length > 0
    #   console.log 'closing modal'
    #   $.modal.close()
    #   console.log 'closed modal'
    # else
    #   console.log 'not found modal'

    if /[^=]\/(awards|biography|contact)/.test(State.url)
      $.colorbox
        opacity: 0.8
        href: State.url
        initialWidth: 326
        width: 360
        height: 350
    else if /[^=]\/videos\/(\d+)/.test(State.url)
      console.log 'videos found in url'
      try
        console.log 'setting modal url'
        console.log 'set modal url'
        console.log 'opening modal'
        # $("<a href='#{State.url}'>modal</a>").modal()
        $.colorbox
          opacity: 0.8
          href: State.url
          initialWidth: 326
          width: 728
          height: 415
        console.log 'opened modal'
      catch error
        console.log error
    else
      $.colorbox.close()

    #   # History.log(State.data, State.title, State.url)

  console.log 'triggering statechange'
  History.Adapter.trigger(window, 'statechange')

