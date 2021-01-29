class UserMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: 'users/mailer'
  
  default from: DO_NOT_REPLY
  layout 'mailer'
end
