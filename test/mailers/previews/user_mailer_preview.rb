# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def invitation_instructions
    UserMailer.invitation_instructions(User.first, "token")
  end
  
  def password_change
    UserMailer.password_change(User.first)    
  end
  
  def reset_password_instructions
    UserMailer.reset_password_instructions(User.first, "token")  
  end
end
