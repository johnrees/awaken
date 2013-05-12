window.showingVideo = false

class Reel

  constructor: (@element) ->
    return false unless window.History.enabled
    @interval = null
    @positions = []
    @acceleration = 0
    thumb = @element.find('.thumb')
    @activeSlide = Math.min(3, thumb.length - 1)
    @thumbWidth = thumb.width()
    @isSwiped = false
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
      else
        @close()
    window.History.Adapter.trigger(window, 'statechange')

  bindEvents: ->
    $('a[data-popup]').click (e) ->
      e.preventDefault()
      window.History.pushState(null, "#{$(this).text()} | James Rouse", $(this).attr('href'))

    $('#overlay').click @close
    $('.polaroid').click @clicked
    $('.bar').mousemove(@mousemoved).mouseout(@reset)

    if Modernizr.touch
      $('#main').swipe
        swipe: @swiped
        tap: @clicked
        allowPageScroll: 'vertical'
    else
      @interval = setInterval(@scroll, 10)
    $(window).resize(=> @reset()).trigger 'resize'

  mousemoved: (e) =>
    TweenLite.killTweensOf @element
    maxSpeed = 10
    xPos = e.pageX
    width = @sideWidth
    if (xPos > @pageWidth - width)
      @acceleration = @map(xPos, @pageWidth - width, @pageWidth, 0, -maxSpeed)
    else if (e.pageX < width)
      @acceleration = @map(xPos, 0, width, maxSpeed, 0)
    else @reset()

  scroll: =>

    if (@acceleration != 0)
      # #console.log @activeSlide
      currentPosition = parseInt @element.css('left')

      newPosition = currentPosition + @acceleration
      newPosition = parseInt Math.max( @maxLeft , Math.min( @minLeft, newPosition) - 2)

      # #console.log @activeSlide, @element.find('.thumb').length
      $('#video-thumbs').css 'left', -> "#{newPosition}px"
      @checkActive()

  swiped: (event, direction, distance, duration, fingerCount) =>

    unless @isSwiped
      @isSwiped = true
      # speed = parseInt @map(distance/duration, 0, 1.5, 1, 2)
      setTimeout( (=> @isSwiped = false), 200)
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
    window.History.pushState(null, "#{name} | James Rouse", link) unless @isSwiped

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
    $('span.kind').text( "#{activeThumb.data('kind')}:" )
    $('span.name').text( activeThumb.data('name') )
    $('span.client_name').text( activeThumb.data('client') )

  reset: =>
    try
      @acceleration = 0
      @sideWidth = $('.left').width()
      @pageWidth = parseInt $(window).width()
      @minLeft = parseInt(@pageWidth/2) - parseInt(@thumbWidth/2) #- 2
      @maxLeft = parseInt(@pageWidth/2) - @element.width() + parseInt(@thumbWidth/2) #- 2
      @positions = _.range(@minLeft + 5, @maxLeft, -315)
      @scrollTo(@activeSlide,0.2)
    # TweenLite.to @element, 0.5,
    #   left: @minLeft - @thumbWidth * @activeSlide - 1

  launch: (type) ->
    $('#popup,#overlay').show()
    switch type
      when 'video'
        TweenMax.to $('#popup'), 0.5, { width: 720, height: 407, top: 0, onComplete: -> $('#close').fadeIn(100) }
        current = $("a[href$='#{window.location.pathname}']").first()
        if current
          $('#video').attr
            src: current.data('video')
            poster: current.data('poster')

          @scrollTo $('.thumb a').index(current)
          $('#video').show()
          @video = videojs "video"
          @video.width '100%'
          @video.height 405
          @video.src [
            {type: 'video/mp4', src: current.data('video')}
            {type: 'video/webm', src: current.data('video').replace('mp4', 'webm')}
            {type: 'video/ogg', src: current.data('video').replace('mp4', 'ogg')}
          ]

          @video.poster current.data('poster')
          @video.play()
      else
        $("##{type}").show()
        TweenMax.to $('#popup'), 0.5, { width: 360, height: 380, top: 0, onComplete: -> $('#close').fadeIn(100) }

  close: ->
    window.History.pushState(null, "James Rouse | Director", '/')
    $('#overlay').hide()
    $('#close').hide()
    if @video
      @video.poster null
      @video.pause()
    TweenMax.to $('#popup'), 0.5, { width: 326, height: 317, top: 9, onComplete: -> $('#popup').hide() }


jQuery ->

  $('#main .inner').hide().load '/videos', ->
    $(this).fadeIn()
    new Reel $('#video-thumbs')
