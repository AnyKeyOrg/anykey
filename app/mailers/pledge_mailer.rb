class PledgeMailer < ApplicationMailer
  
  default from: DO_NOT_REPLY

  def welcome_pledger(pledge)
    @pledge = pledge
    mail(to: pledge.email, subject: "Thank you for taking the GLHF pledge!")
  end
  
end
