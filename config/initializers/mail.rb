DO_NOT_REPLY = "AnyKey <keybot@anykey.org>"

ActionMailer::Base.smtp_settings = {
  address:                "smtp.sendgrid.net",
  port:                   587,
  authentication:         :plain,
  enable_starttls_auto:   true,
  user_name:              ENV['SENDGRID_USERNAME'],
  password:               ENV['SENDGRID_PASSWORD'],
  domain:                 ENV['SENDGRID_DOMAIN']
}
