module Appointments
  class Form
    include ActiveModel::Model
    attr_reader :doctor_id, :patient_id, :scheduled

    validates_presence_of :patient_id, :scheduled

    def initialize(doctor_id, patients_store, params = {})
      @doctor_id = doctor_id
      @patients_store = patients_store
      @patient_id = params["patient_id"]
      @scheduled = params["scheduled"]
    end

    def patients_options
      patients_store.patient_with_doctor_id(doctor_id).map do |patient|
        [patient.full_name, patient.id]
      end
    end

    def to_h
      {
        doctor_id: doctor_id,
        patient_id: patient_id,
        scheduled: scheduled
      }
    end

    private
    attr_reader :patients_store
  end
end
