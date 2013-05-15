window.players = []

class Reel

  constructor: (@element) ->
    return false unless window.History.enabled
    @interval = null
    @positions = []
    @acceleration = 0
    thumb = @element.find('.thumb')
    @activeSlide = Math.min(3, thumb.length - 1)
    @setupHistory()
    @bindEvents()

  setupHistory: =>
    $(window).bind 'statechange', =>
      State = window.History.getState()
      $('#pages > div,#video').hide()
      if /[^=]\/(awards|biography|contact)/.test(State.url)
        @launch State.url.split('/').pop()
      else if /[^=]\/videos\/(\d+)/.test(State.url)
        @launch 'video'
      else if $('#video-modal').is(":visible")
        @close()
    window.History.Adapter.trigger(window, 'statechange')

  bindEvents: ->
    $('a[data-popup]').click (e) ->
      e.preventDefault()
      window.History.pushState(null, "#{$(this).text()} | James Rouse", $(this).attr('href'))

    $('#overlay,#close').click (e) ->
      e.preventDefault()
      window.History.pushState(null, "James Rouse | Director", '/')

    $('#polaroid').click @clicked
    $('.bar').mousemove(@mousemoved).mouseout(@reset)

    if Modernizr.touch
      $('#main').swipe
        swipeLeft: @swiped
        swipeRight: @swiped
        tap: @clicked
        allowPageScroll: 'vertical'
    else
      @interval = setInterval(@scroll, 10)
    $(window).resize(@reset).trigger 'resize'

  mousemoved: (e) =>
    TweenLite.killTweensOf @element
    maxSpeed = 10
    xPos = e.pageX
    width = @sideWidth
    # console.log width
    if (xPos > @pageWidth - width)
      @acceleration = @map(xPos, @pageWidth - width, @pageWidth, 0, -maxSpeed)
    else if (e.pageX < width)
      @acceleration = @map(xPos, 0, width, maxSpeed, 0)
    else @reset()

  scroll: =>

    if (@acceleration != 0)
      currentPosition = parseInt @element.css('left')

      newPosition = currentPosition + @acceleration
      newPosition = parseInt Math.max( @maxLeft , Math.min( @minLeft, newPosition) - 2)

      $('#video-thumbs').css 'left', -> "#{newPosition}px"
      @checkActive()

  swiped: (event, direction, distance, duration, fingerCount) =>
    setTimeout( (=> @isSwiped = false), 200)
    console.log direction
    switch direction
      when 'right'
        slide = Math.max(@activeSlide-1, 0)
      when 'left'
        slide = Math.min(@activeSlide+1, (@element.find('.thumb').length - 1))
    @scrollTo(slide,0.3)

  clicked: (e, target=null) =>
    e.preventDefault()
    if target != null
      return if $(target).hasClass('bar')

    current = $(".thumb:eq(#{@activeSlide}) a:first-child")
    link = current.attr('href')
    name = current.data('name')
    window.History.pushState(null, "#{name} | James Rouse", link)# unless @isSwiped

  map: (x, in_min, in_max, out_min, out_max) ->
    (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

  checkActive: ->
    goal = parseInt @element.css('left')
    closest = closestIndex = null

    $.each @positions, (index, value) ->
      if (closest == null || Math.abs(value - goal) < Math.abs(closest - goal))
        closest = value
        closestIndex = index

    @activeSlide = closestIndex
    @updateGUI()

  scrollTo: (slide, time = 0.3) ->
    @activeSlide = slide

    newPosition = @minLeft - @thumbWidth * slide - 2
    unless isNaN(newPosition)
      TweenLite.to @element, time, left: newPosition
    @updateGUI()


  updateGUI: ->
    activeThumb = $(".thumb:eq(#{@activeSlide}) a:first-child")
    $('span#video-kind').text( "#{activeThumb.data('kind')}:" )
    $('span#video-name').text( activeThumb.data('name') )
    $('span#video-client').text( activeThumb.data('client') )

  reset: =>
    try
      @acceleration = 0
      @thumbWidth = @element.find('.thumb').width()
      @sideWidth = $('.bar').width()
      @pageWidth = parseInt $(window).width()
      @minLeft = parseInt(@pageWidth/2) - parseInt(@thumbWidth/2) #- 2
      @maxLeft = parseInt(@pageWidth/2) - @element.width() + parseInt(@thumbWidth/2) - 1
      @positions = _.range(@minLeft + 5, @maxLeft, -$('.thumb').width())
      @scrollTo(@activeSlide,0.2)

  launch: (type) ->
    $('#popup,#overlay').show()
    switch type
      when 'video'
        current = $("a[href*='#{window.History.getState().url.split('/').pop()}']").first()
        small = $(window).width() < 500
        if current
          console.log $('a.video-link').index(current)
          $('#video-modal').append current.parents('li').find('.popup')
          @scrollTo $('a.video-link').index(current)
          TweenMax.to $('#popup'), 0.5, { width: 720, height: 410, top: 0, onComplete: -> $('#close').fadeIn(100).css('display', 'block') }

          player = $('#video-modal video')[0]
          try
            setTimeout (-> player.play()), 100
          catch error
            console.log error

          # player.hideControls()
          # player.setVolume(0.8)
          # player.load()
          $('#video-modal video').on 'webkitendfullscreen', => window.History.pushState(null, "James Rouse | Director", '/')

      else
        $("##{type}").show()
        TweenMax.to $('#popup'), 0.5, { width: 360, height: 380, top: 0, onComplete: -> $('#close').fadeIn(100).css('display', 'block') }

  close: ->
    $('#overlay,#close').hide()

    TweenMax.to $('#popup'), 0.5, { width: $('#polaroid').width(), height: $('#polaroid').height(), top: 12, onComplete: ->
      $('#popup').hide()
      if $('#video-modal video').length > 0
        try
          $('#video-modal video').get(0).player.pause()
        catch error
          console.log error
        $('li.thumb:not(:has(.popup))').append $('#video-modal .popup')
    }


jQuery ->
  $('#main .inner').hide().load '/videos', ->
    $(this).fadeIn()
    new Reel $('#video-thumbs')
    $('video').mediaelementplayer
      enablePluginDebug: true
      plugins: ['flash']
      # defaultVideoWidth: 710
      # defaultVideoHeight: 400
      videoWidth: '100%'
      videoHeight: 400
      success: (player, node) ->
        window.players.push player
