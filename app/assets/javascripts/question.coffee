$ ->
  $('.question_wrapper').bind 'ajax:success', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    $('.question_votes').html(JST["templates/votes_bar"]({object: question}))