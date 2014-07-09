readyCallback = ->
  $('.point .streetview').each( ->
    id = $(this).attr('id')
    point = $("##{id}")
    streetview = point.data('streetview')

    $.ajax({
      url: streetview
    }).done (data) ->
      if data.available
        point.append $('<img/>').attr('src', data.image)
  )

$(document).ready(readyCallback)
$(document).on('page:load', readyCallback)