window.showingVideo = false

class Reel

  constructor: (@element) ->
    @positions = []
    @acceleration = 0
    thumb = @element.find('.thumb')
    @activeSlide = Math.min(3, thumb.length - 1)
    @thumbWidth = thumb.width()
    @isSwiped = false
    $(window).resize(=> @reset()).trigger 'resize'

    $('.box').click @clicked
    $('.holder').mousemove(@mousemoved).mouseout(@reset)

    $(document).bind 'cbox_complete', =>
      current = $("a[href$='#{window.location.pathname}']").first()

      @activeSlide = $('.thumb a').index(current)
      console.log "a[href$='#{window.location.pathname}']"
      @reset()
      videojs("video").play() if window.showingVideo

    if Modernizr.touch
      $('#main').swipe
        swipe: @swiped
        allowPageScroll: 'vertical'
    else
      setInterval(@scroll, 10)

  mousemoved: (e) =>
    TweenLite.killTweensOf @element
    maxSpeed = 10
    xPos = e.pageX
    width = $('.left').width()
    if (xPos > @pageWidth - width)
      @acceleration = @map(xPos, @pageWidth - width, @pageWidth, 0, -maxSpeed)
    else if (e.pageX < width)
      @acceleration = @map(xPos, 0, width, maxSpeed, 0)
    else @reset()

  scroll: =>

    if (@acceleration != 0)
      # console.log @activeSlide
      currentPosition = parseInt @element.css('left')

      newPosition = currentPosition + @acceleration
      newPosition = parseInt Math.max( @maxLeft, Math.min( @minLeft, newPosition))

      # console.log @activeSlide, @element.find('.thumb').length
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
          slide = Math.min(@activeSlide+1, @element.find('.thumb').length)
      @scrollTo(slide,0.3)

  clicked: (e) =>
    e.preventDefault()
    current = $(".thumb:eq(#{@activeSlide}) a:first-child")
    link = current.attr('href')
    name = current.data('name')
    History.pushState(null, "#{name} | James Rouse", link) unless @isSwiped

  map: (x, in_min, in_max, out_min, out_max) ->
    (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

  checkActive: ->
    goal = parseInt @element.css('left')
    closest = null
    closestIndex = null
    $.each @positions, (index, value) ->
      if (closest == null || Math.abs(value - goal) < Math.abs(closest - goal))
        closest = value
        closestIndex = index
    # if closestIndex != null
    # window.active = closest - window.padding
    @activeSlide = closestIndex
    @updateGUI()

  updateGUI: ->
    activeThumb = $(".thumb:eq(#{@activeSlide}) a:first-child")
    $('span.kind').text( "#{activeThumb.data('kind')}:" )
    $('span.name').text( activeThumb.data('name') )
    $('span.client_name').text( activeThumb.data('client') )

  scrollTo: (slide, time = 0.3) ->
    @activeSlide = slide
    TweenLite.to @element, time,
      left: @minLeft - @thumbWidth * slide# - 2
    @checkActive()
    @updateGUI()


  reset: () =>
    @acceleration = 0
    @pageWidth = parseInt $(window).width()
    @minLeft = parseInt(@pageWidth/2 - @thumbWidth/2 - 1)
    @maxLeft = parseInt(@pageWidth/2 - @element.width() + @thumbWidth/2 - 1)
    @positions = _.range(@minLeft + 2, @maxLeft, -315)
    @scrollTo(@activeSlide,0.2)
    # TweenLite.to @element, 0.5,
    #   left: @minLeft - @thumbWidth * @activeSlide - 1


class Delorean

  constructor: ->
    History = window.History
    return false unless History.enabled

    $(document).bind 'cbox_closed', ->
      History.pushState("James Rouse | Director", null, '/')

    $(window).bind 'statechange', ->
      State = History.getState()

      if /[^=]\/(awards|biography|contact)/.test(State.url)
        window.showingVideo = false
        $.colorbox
          opacity: 0
          href: State.url
          initialWidth: 326
          initialHeight: 317
          width: 360
          height: 380

      else if /[^=]\/videos\/(\d+)/.test(State.url)
        window.showingVideo = true
        console.log 'videos found in url'
        current = $("a[href$='#{window.location.pathname}']").first()
        videojs("video").src(current.data('video'))
        try
          console.log 'setting modal url'
          console.log 'set modal url'
          console.log 'opening modal'
          # $("<a href='#{State.url}'>modal</a>").modal()
          $.colorbox
            opacity: 0
            href: '#video-modal'
            inline: true
            # src:
            # href: State.url
            initialWidth: 326
            initialHeight: 317
            width: 728
            height: 415

          console.log 'opened modal'
        catch error
          console.log error
      else
        window.showingVideo = false
        if $('#colorbox').length > 0
          $.colorbox.close()

    History.Adapter.trigger(window, 'statechange')


jQuery ->

  $('#main .inner').hide().load '/videos', ->
    $(this).fadeIn()

    reel = new Reel $('#video-thumbs')
    new Delorean



    $('a[data-popup]').click (e) ->
      e.preventDefault()
      History.pushState(null, "#{$(this).text()} | James Rouse", $(this).attr('href'))

