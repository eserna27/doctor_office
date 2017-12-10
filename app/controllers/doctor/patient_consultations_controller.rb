class Doctor::PatientConsultationsController < ApplicationController
  def index
    consultation_view = Patients.list_consultations(params[:patient_id], current_doctor.id, Consultation, Patient)
    render :index, locals: {consultation_view: consultation_view}
  end

  def show
    consultation = Consultations.show_consultation(
      {id: params[:id], patient_id: params[:patient_id], doctor_id: current_doctor.id},
      Consultation)

    render :show, locals: {consultation: consultation, link_origin: params[:link_origin]}
  end
end
