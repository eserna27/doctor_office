require "active_support"
require_relative 'appointments/form'
require_relative 'status'

module Appointments
  def self.new_appointment_form(doctor_id, patients_store)
    Form.new(doctor_id, patients_store)
  end

  def self.create_appointment(doctor_id, params, appointment_store, patients_store)
    form = Form.new(doctor_id, patients_store, params)
    if form.valid?
      appointment_store.create(form.to_h)
      Status::Success
    else
      Status::Error.new(form)
    end
  end

  def self.accept(appointment_id, confidencial_id, appointment_store)
    update_status(:accepted, appointment_id, confidencial_id, appointment_store)
  end

  def self.cancel(appointment_id, confidencial_id, appointment_store)
    update_status(:canceled, appointment_id, confidencial_id, appointment_store)
  end

  private

  def self.update_status(status, appointment_id, confidencial_id, appointment_store)
    appointment = appointment_store.find_by({confidencial_id: confidencial_id})
    if appointment
      appointment_store.update(appointment_id, status: status)
      Status::Success
    else
      Status::Error
    end
  end
end
