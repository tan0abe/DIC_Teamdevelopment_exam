class ChangeOwnerMailer < ApplicationMailer
  default from: 'from@example.com'

  def change_owner_mail(team_name,owner_email_before,email)
    @email = email
    @owner_email_before = owner_email_before
    @team_name = team_name
    mail to: @email, subject: 'オーナーに任命されました！！'
  end
end
