
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


jQuery ->

  $("#multi").bsmSelect
    plugins: [ $.bsmSelect.plugins.sortable() ]
    removeClass: 'btn'
  $('select#multi').change ->
    $('form#update_frontpage_items').submit()

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

  $('#videos').sortable
    axis: 'y'
    update: ->
      $.post($(this).data('url'), $(this).sortable('serialize'))


  $('#capture').click (e) ->
    e.preventDefault()
    ctx = canvas.getContext('2d')
    ctx.drawImage(window.video, 0, 0, canvas.width, canvas.height)
    url = canvas.toDataURL()
    console.log url
    # window.capture()
    # console.log document.getElementById('canvas').toDataURL()

    # $.post "screenshot",
    #   { bitmapdata: document.getElementById('canvas').toDataURL() }, (data) ->
    #     alert("Data Loaded: " + data)
