class DestroyAgendaMailer < ApplicationMailer
  default from: 'from@example.com'

   def destroy_agenda_mail(agenda, member)
    @agenda = agenda
    mail to: member.email, subject: 'アジェンダを削除'
  end
end
