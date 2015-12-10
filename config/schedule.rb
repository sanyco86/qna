set :output, "#{path}/log/cron.log"

every 1.days do
  puts "#{Time.now} Starting send_daily_digest."
  runner 'User.send_daily_digest'
  puts "#{Time.now} Done"
end

every 15.minutes do
  puts "#{Time.now} Starting notify_new_answers."
  runner 'Answer.notify_new_answers'
  puts "#{Time.now} Done"
end