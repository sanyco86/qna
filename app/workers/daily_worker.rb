class DailyWorker
  include Sidekiq::Worker

  def perform(user_id, question_ids)
    DailyMailer.digest(user_id, question_ids).deliver_later
  end
end