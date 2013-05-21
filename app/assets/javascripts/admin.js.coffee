
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
  e.preventDefault()
  div = $(e.currentTarget).parents('.upload')
  template = div.get(0)
  console.log template
  data = $(template).data() || {}
  if data.jqXHR
    data.jqXHR.abort()
    div.fadeOut('fast')
  else
    data.errorThrown = 'abort'
    this._trigger('fail', e, data)

jQuery ->

  $(document).on 'click', '.abort', window.abortUpload

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
    maxFileSize: 1073741824
    acceptFileTypes: /(\.|\/)(avi|wmv|mpg|mpeg|flv|m4v|dat|m1v|m2v|mov|ogg)$/i
    dataType: "script"
    add: (e, data) ->
      data.context = tmpl("template-upload", data.files[0]).trim()

      $('#new_video').append(data.context)
      # $('.upload:last').data('p','ee')
      # $(data.context)
      $('.upload:last').data('jqXHR', data.submit())
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        if progress >= 100
          $(".upload[data-name='#{data.files[0].name}'] .progress").html("Transferring to Video Server...")
        else
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
      $.post '/admin/videos/sort', "_method=put&#{$('#published-videos').sortable('serialize')}"

  $('#unpublished-videos').disableSelection().sortable
    items:'li.video'
    connectWith: '.list'
    update: ->
      $.post '/admin/videos/disable', "_method=put&#{$('#unpublished-videos').sortable('serialize')}"

  $('#pages').disableSelection().sortable
    items:'li.page'
    axis:'y'
    update: ->
      $.post '/admin/pages/sort', "_method=put&#{$('#pages').sortable('serialize')}"

  # $('#page_permalink').keyup ->
  #   v = $(this).val() || "PERMALINK"
  #   $('span.permalink').text(v)
  # .trigger('keyup')

  $('#page_name').change ->
    $('#page_permalink').val($(this).val()).trigger('change') unless $('#page_permalink').val()

  $('#page_permalink').change ->
    clean = $(this).val().trim().toLowerCase().replace(/\s/g, '-').replace(/[^a-z0-9\-]/g, '')
    $(this).val(clean)

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
