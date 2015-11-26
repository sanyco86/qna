$ ->
  $('body').on 'click', '.answer_edit-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer_' + answer_id).show()

  $('form.new_answer').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.answer-errors').html('')
    $.each errors, (index, value) ->
      $('.answer-errors').append value

  $('form.answer_edit-form').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answer_edit-form').hide()
    $('#answer_' + answer.id).replaceWith(JST["templates/answer"]({answer: answer, current_user_id: currentUserId}))
    $('.answer_edit-link').show()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    for value in errors
      $(this).prev().remove("p.error")
      $(this).before '<p class="error">' + value + '</p>'

  $('.answer_wrapper').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $("#answer_#{answer.id} .answer_votes").html(JST["templates/votes_bar"]({object: answer}))

  questionId = $('#answers').data('questionId')
  currentUserId = $('body').data('currentUserId')

  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    answer = $.parseJSON(data['answer'])
    answers_container = $('.answers_list')
    answers_container.append(JST["templates/answer"]({answer: answer, current_user_id: currentUserId}))
    $("#answers").removeClass 'hidden'
    $('.form-control#answer_body').val('')
    $('.answer-errors').html('')