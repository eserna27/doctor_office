class Doctor::PatientsController < ApplicationController
  def new
    form = Doctors.new_patient(doctor_id: current_doctor.id)
    render :new, locals: {form: form}
  end

  def create
    status = Doctors.create_patient(params[:patient].merge(doctor_id: current_doctor.id), Patient)
    if status.success?
      redirect_to doctor_patients_path
    else
      render :new, locals: {form: status.form}
    end
  end

  def index
    patients = Doctors.list_patients(current_doctor.id, Patient)
    render :index, locals: {patients: patients}
  end
end
