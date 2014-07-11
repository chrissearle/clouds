readyCallback = ->
  $('.point').each( ->
    id = $(this).attr('id')
    point = $("##{id}").find('.streetview')
    streetview = point.data('streetview')

    $.ajax({ url: streetview }).done (data) ->
      if data.available
        point.append $('<img/>').attr('src', data.image)


    $(this).click ->
      new google.maps.event.trigger( $(this).data('marker'), 'click' )
  )

  resizePoints()

  $(window).resize ->
    resizePoints()

resizePoints = ->
  $('.scrollable').height($( window ).height() - 70)

$(document).ready(readyCallback)
$(document).on('page:load', readyCallback)