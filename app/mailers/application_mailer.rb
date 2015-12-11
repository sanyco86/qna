class ApplicationMailer < ActionMailer::Base
  default from: 'it@tis-ruda.com'
  layout 'mailer'
  default template_path: 'mailers'
end
