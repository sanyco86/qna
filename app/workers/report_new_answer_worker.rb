class ReportNewAnswerWorker
  include Sidekiq::Worker

  def perform(subscriber_id, answers_ids)
    ReportNewAnswerMailer.report_new_answer(subscriber_id, answers_ids).deliver_later
  end
end