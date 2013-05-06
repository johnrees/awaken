
window.capture = (video, scaleFactor = 1) ->
  video = document.getElementById('my_video_1')
  video.crossOrigin = 'anonymous';
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


  $(document).foundation()

  $('#videos').sortable
    axis: 'y'
    update: ->
      $.post($(this).data('url'), $(this).sortable('serialize'))

  $('#capture').click (e) ->
    e.preventDefault()
    window.capture()
    # console.log document.getElementById('canvas').toDataURL()

    # $.post "screenshot",
    #   { bitmapdata: document.getElementById('canvas').toDataURL() }, (data) ->
    #     alert("Data Loaded: " + data)
