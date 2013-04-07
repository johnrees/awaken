scroll = ->
  TweenLite.to($('.thumbs'), 0.2, {left: $('.thumbs').css('left')});

jQuery ->

  $(window).resize ->
    $('.text').html 'a'

  $(document).mousemove (e) ->
    if (e.pageX > $('body').width() - 50)
      setInterval(scroll, 1000);
