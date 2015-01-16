class AutoMail < ActionMailer::Base
  default from: "kykoyo1992@gmail.com"

  def auto_mail(user)
    mail to: user.email, subject: 'Invitation for RockIT CoLabs member'
  end
end
