$ ->
  $('.js-stats-link').on 'click', ->
    $(@).addClass('current').siblings().removeClass('current')
    $('.js-stats-current-label').text($(@).text())
    $containerToShow = $($(@).attr('href'))
    $('.js-stats-container:visible').fadeOut ->
      $containerToShow.fadeIn()
    return false
