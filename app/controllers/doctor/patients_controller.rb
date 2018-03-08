class Doctor::PatientsController < ApplicationController
  def new
    form = Patients.create_patient_form(current_doctor.id)
    render :new, locals: {form: form}
  end

  def create
    status = Patients.create_patient(params[:patient].merge(doctor_id: current_doctor.id), Patient)
    if status.success?
      redirect_to doctor_patients_path, alert: "Paciente creado"
    else
      render :new, locals: {form: status.form}
    end
  end

  def edit
    form = Patients.update_patient_form(patien_id, Patient)
    render :edit, locals: {form: form, patien_id: patien_id}
  end

  def update
    status = Patients.update_patient(patien_id, params[:patient].merge!(doctor_id: current_doctor.id), Patient)
    if status.success?
      redirect_to doctor_patients_path, alert: "Paciente actualizado"
    else
      render :edit, locals: {form: status.form, patien_id: patien_id}
    end
  end

  def index
    patients = Doctors.list_doctor_patients(current_doctor.id, Patient)
    render :index, locals: {patients: patients, doctor_id: current_doctor.id}
  end

  private

  def patien_id
    params[:id]
  end
end
