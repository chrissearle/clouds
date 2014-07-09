readyCallback = ->
  $('.point .streetview').each( ->
    id = $(this).attr('id')
    point = $("##{id}")
    image = point.data('image')

    $.ajax({
      crossDomain: true,
      url: image,
      type: 'HEAD'
    }).done (res, status, xhr) ->
      console.log(xhr.getAllResponseHeaders())
      console.log xhr.getResponseHeader('Content-Length')

    point.append $('<img/>').attr('src', point.data('image'))
  )

$(document).ready(readyCallback)
$(document).on('page:load', readyCallback)