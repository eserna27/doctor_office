class Doctor::ConsultationsController < ApplicationController
  def new
    form = Consultations.new_consultation_with_time({time: params[:time], doctor_id: current_doctor.id}, Patient)
    render :new, locals: {form: form}
  end

  def index
    week_view = Calendar.week_view(date_param, DateTime.now, Consultation, current_doctor.id)
    render :index, locals: {week_view: week_view}
  end

  def create
    status = Consultations.create_consultation(
      params[:consultation].merge(doctor_id: current_doctor.id),
      Consultation,
      Patient)
    if status.success?
      redirect_to doctor_consultations_path
    else
      render :form_with_errors, locals: {form: status.form}
    end
  end

  private

  def date_param
    params[:date] ? DateTime.parse(params[:date]) : DateTime.now
  end
end
