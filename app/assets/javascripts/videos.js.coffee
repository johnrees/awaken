window.acceleration = 0

scroll = ->
  $('.thumbs').css 'left', (index, curValue) ->
    "#{parseInt(curValue) + window.acceleration}px"

setInterval(scroll, 20)

jQuery ->

  $('a[data-popup]').colorbox
    initialWidth: 326
    width: 360
    height: 350

  $(window).resize ->
    $('.text').html 'a'

  $(document).mousemove (e) ->
    if (e.pageX > $('body').width() - 50)
      window.acceleration = -3
    else if (e.pageX < 50)
      window.acceleration = 3
    else
      window.acceleration = 0
