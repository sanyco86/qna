$ ->
  $('.answer__edit-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer_' + answer_id).show()