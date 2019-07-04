class ChangeOwnerMailer < ApplicationMailer
  default from: 'from@example.com'

    def change_owner_mail(team)
    @team = team
    mail to: @team.members.name, subject: 'オーナーに任命されました！'
  end
end
