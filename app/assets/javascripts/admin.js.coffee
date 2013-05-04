# window.shoot = ->
#   # output = document.getElementById('output')
#   $(document).html capture(video)
#   # canvas.onclick = ->
#   # $('img#thumb').attr('src',canvas.toDataURL())
#   console.log canvas
#   # snapshots.unshift(canvas)
#   # output.innerHTML = '';
#   #   for(var i=0; i<1; i++){
#   #       output.appendChild(snapshots[i]);
#   #   }

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

  $('#capture').click (e) ->
    e.preventDefault()
    window.capture()
    # console.log document.getElementById('canvas').toDataURL()

    # $.post "screenshot",
    #   { bitmapdata: document.getElementById('canvas').toDataURL() }, (data) ->
    #     alert("Data Loaded: " + data)
