json.extract! @answer, :id, :question_id, :body, :created_at, :updated_at
json.user @answer.user, :id, :email
json.update_url  answer_path(@answer)
json.destroy_url answer_path(@answer)
json.make_best_url make_best_answer_path(@answer)
json.current_user_id current_user.id
json.question_user_id @answer.question.user_id

json.attachments @answer.attachments do |a|
  json.id a.id
  json.file_name a.file.identifier
  json.file_url a.file.url
end