class ApplicationMailer < ActionMailer::Base
  default from: 'lutsko86@gmail.com'
  layout 'mailer'
  default template_path: 'mailers'
end
