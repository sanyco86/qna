class ReportWorker
  include Sidekiq::Worker

  def perform(subscriber_id, answer_id)
    ReportMailer.report(subscriber_id, answer_id).deliver_later
  end
end