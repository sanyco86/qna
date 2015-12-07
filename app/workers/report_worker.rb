class ReportWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely(15) }
  #recurrence { hourly.minute_of_hour(0, 15, 30, 45) }

  def perform(subscriber_id, answer_id)
    ReportMailer.report(subscriber_id, answer_id).deliver
  end
end