class DailyWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily(1) }

  def perform(user_id, question_ids)
    DailyMailer.digest(user_id, question_ids).deliver
  end
end