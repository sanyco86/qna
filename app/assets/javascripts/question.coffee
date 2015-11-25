$ ->
  $('.question_wrapper').bind 'ajax:success', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    $('.question_votes').html(JST["templates/votes_bar"]({object: question}))

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('#questions').append(JST["templates/question"]({question: question}))