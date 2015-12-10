json.extract! @question, :id, :title, :user_id
json.update_url  edit_question_path(@question)
json.destroy_url question_path(@question)
json.votes_count @question.votes.count
json.answers_count @question.answers.count