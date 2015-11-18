$ ->
  $('#answers').on 'click', '.answer_edit-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer_' + answer_id).show()

  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('#answers').append(JST["templates/answer"]({answer: answer}))
    $('.form-control#answer_body').val('')

  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.answer-errors').html('')
    $.each errors, (index, value) ->
      $('.answer-errors').append value