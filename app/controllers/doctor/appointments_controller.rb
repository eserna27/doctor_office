class Doctor::AppointmentsController < ApplicationController
  def new
    form = Appointments.new_appointment_form(doctor_id, Patient)
    render locals: {form: form}
  end

  def create
    status = Appointments.create_appointment(doctor_id, params[:appointment], nil, Patient)
    if status.success?
    else
      render :new, locals: {form: status.form}
    end
  end

  private
  def doctor_id
    current_doctor.id
  end
end
