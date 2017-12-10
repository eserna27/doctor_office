require "active_model"

module Doctors
  def self.new_patient(attrs)
    PatientForm.new(attrs)
  end

  def self.create_patient(attrs, patient_store)
    form = PatientForm.new(attrs)
    if form.valid?
      patient_store.create(form.to_h)
      SuccessStatus.new
    else
      ErrorStatus.new(form)
    end
  end

  def self.edit_patient(patient_id, patient_store)
    PatientForm.edit_patient(patient_store.find(patient_id))
  end

  def self.update_patient(patient_id, patient_attrs, patient_store)
    form = PatientForm.new(patient_attrs.merge(id: patient_id))
    if form.valid?
      patient_store.update(patient_id, form.to_h)
      SuccessStatus.new
    else
      ErrorStatus.new(form)
    end
  end

  def self.list_patients(doctor_id, patient_store)
    patient_store.patient_with_doctor_id(doctor_id)
  end

  class PatientForm
    include ActiveModel::Model

    ATTRS = [:name, :last_name, :email, :gender, :doctor_id]

    attr_accessor(:id, *ATTRS)
    validates_presence_of(*ATTRS)

    def initialize(attrs)
       ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
       @id = attrs[:id] if attrs[:id]
    end

    def self.edit_patient(patient_for_store)
      new({
          id: patient_for_store.id,
          name: patient_for_store.name,
          last_name: patient_for_store.last_name,
          email: patient_for_store.email,
          gender: patient_for_store.gender
        })
    end

    def to_h
      ATTRS.map{|attr| [attr, send(attr)]}.to_h
    end
  end

  class SuccessStatus
    def success?
      true
    end
  end

  class ErrorStatus
    attr_reader :form
    def initialize(form)
      @form = form
    end

    def success?
      false
    end
  end
end
