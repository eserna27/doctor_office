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
      Status::Success.new
    else
      Status::Error.new(form)
    end
  end
end
