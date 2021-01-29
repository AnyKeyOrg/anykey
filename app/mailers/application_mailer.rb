class ApplicationMailer < ActionMailer::Base
  default from: DO_NOT_REPLY
  layout 'mailer'
end
