
window.capture = (video, scaleFactor = 1) ->
  video = document.getElementById('my_video_1')
  w = video.videoWidth * scaleFactor
  h = video.videoHeight * scaleFactor
  canvas = document.getElementById('canvas')
  canvas.width  = w
  canvas.height = h
  ctx = canvas.getContext('2d')
  ctx.drawImage(video, 0, 0, w, h)

  $.post "screenshot",
    { bitmapdata: canvas.toDataURL() }, (data) ->
      alert("Data Loaded: " + data)

  return canvas


resetThumbnails = ->
  if $('#thumbnails').length
    TweenLite.to($('ul#thumbnails'), 0.5, {
      scrollTop: parseInt($('#video_thumbnail').val().match(/_(\d+).jpg/)[1]) * $('.active.thumbnail').height()
    })

VideoPoller =
  poll: ->
    setTimeout @request, 5000
  request: ->
    $.getJSON $('#video-section').data('url'), (data) ->
      if data
        console.log 'got'
        $('.waiting').remove()
        $('.processed').show()
      else
        console.log 'check'
        $('.waiting').show()
        VideoPoller.poll()


window.abortUpload = (e) ->
  alert 'ABORT'
  e.preventDefault()
  template = $(e.currentTarget).closest('.upload')
  data = template.data('data') || {}
  if data.jqXHR
    data.jqXHR.abort()
  else
    data.errorThrown = 'abort'
    this._trigger('fail', e, data)

jQuery ->

  featureList = new List 'manage-videos',
    valueNames: [ 'name', 'id', 'c', 'k' ]

  $('form').h5Validate()
  $(".knob").knob()

  if $('body.a_edit.admin.c_videos').length or $('body.a_update.admin.c_videos').length
    $('.waiting').hide()
    $('.processed').hide()
    VideoPoller.request()

  $(window).resize ->
    resetThumbnails()

  $(window).load ->
    resetThumbnails()

  $('#thumbnail-column').mouseleave ->
    resetThumbnails()

  $('ul#thumbnails li.thumbnail').click ->
    img =$(this).find('img').attr('src')
    $('#video_thumbnail').val(img)
    $('li.thumbnail').removeClass('active')
    $('#my_video_1').attr('poster', img.replace('thumbnail','poster'))
    $('#my_video_1').get(0).pause()
    $(this).addClass('active')

  $("#multi").bsmSelect
    plugins: [ $.bsmSelect.plugins.sortable() ]
    removeClass: 'btn'

  $('select#multi').change ->
    $('form#update_frontpage_items').submit()

  $('#new_video').fileupload
    paramName: 'video[attachment]'
    dataType: "script"
    add: (e, data) ->
      data.context = tmpl("template-upload", data.files[0]).trim()
      console.log $(data.context).find('.abort')

      $('#new_video').append(data.context)

      xhr = data.submit()
      $(data.context).data('data', {jqXHR: xhr})
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        $(".upload[data-name='#{data.files[0].name}'] .bar").css('width', progress + '%')
    # done: (e, data) ->


  window.video = document.createElement('video')
  window.video.crossOrigin = 'anonymous'
  window.video.src = $('#video-holder').data('url')

  # canvas = document.getElementById('canvas')
  # video.onload = (e) ->
  #   alert 'a'
  #   # canvas.width  = w
  #   # canvas.height = h
  #   ctx = canvas.getContext('2d')
  #   ctx.drawImage(window.video, 0, 0, canvas.width, canvas.height)
  #   url = canvas.toDataURL()
  #   console.log url


  # console.log video
  # $('#video-holder').html(video)

  $('.abort').on 'click', ->
    alert 'ABOOOORT'


  $(document).foundation()

  # $('#videos').sortable
  #   axis: 'y'
  #   update: ->
  #     $.post($(this).data('url'), $(this).sortable('serialize'))
  #     console.log $(this).sortable('serialize')

  $('#published-videos').disableSelection().sortable
    items:'li.video'
    connectWith: '.list'
    # containment:'parent'
    # axis:'y'
    update: ->
      # console.log '_method=put&'+$(this).sortable('serialize')
      console.log "_method=put&##{$('#published-videos').sortable('serialize')}"
      $.post '/admin/videos/sort', "_method=put&#{$('#published-videos').sortable('serialize')}"

  $('#unpublished-videos').disableSelection().sortable
    items:'li.video'
    connectWith: '.list'
    update: ->
      # console.log '_method=put&'+$(this).sortable('serialize')
      # console.log "_method=put&##{$('#published-videos').sortable('serialize')}"
      $.post '/admin/videos/disable', "_method=put&#{$('#unpublished-videos').sortable('serialize')}"

  # $('#capture').click (e) ->
  #   e.preventDefault()
  #   ctx = canvas.getContext('2d')
  #   video = document.getElementById('my_video_1')
  #   w = video.videoWidth * 1
  #   h = video.videoHeight * 1
  #   ctx.drawImage(video, 0, 0, w, h)
  #   url = canvas.toDataURL()
  #   # console.log url

  #   $.post "screenshot", { bitmapdata: url }, (data) ->
  #     alert("Data Loaded: " + data)
  #   # window.capture()
  #   # console.log document.getElementById('canvas').toDataURL()
  $('.alert').delay(1000).fadeOut()


  window.onbeforeunload = ->
    "Have all your videos been uploaded?" if $('.upload').is(':visible')
