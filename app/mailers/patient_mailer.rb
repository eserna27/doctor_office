class PatientMailer < ApplicationMailer
  def accept_or_cancel_consultation_mail(mail_view)
    @mail_view = mail_view
    mail(to: mail_view.patient_email, subject: "Consulta Medica con #{mail_view.doctor_name}")
  end
end
