every 1.days do
  runner 'User.send_daily_digest'
end

every 15.minutes do
  runner 'Answer.notify_new_answers'
end