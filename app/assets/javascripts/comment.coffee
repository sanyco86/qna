$ ->
  $('.question_wrapper form.new_comment').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    for value in errors
      $(this).prev().remove("p.error")
      $(this).before '<p class="error">' + value + '</p>'

  $('.answer_wrapper form.new_comment').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    for value in errors
      $(this).prev().remove("p.error")
      $(this).before '<p class="error">' + value + '</p>'

  questionId = $('#answers').data('questionId')

  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    console.log comment
    if comment.commentable_type == 'Question'
      $('.question_comments').append(JST["templates/comment"]({comment: comment}))
      $('.question_wrapper #comment_body').val('')
    else
      answersWrapper = $("#answer_#{comment.commentable_id} .answer_comments")
      answersWrapper.append(JST["templates/comment"]({comment: comment}))
      $('.answer_wrapper #comment_body').val('')