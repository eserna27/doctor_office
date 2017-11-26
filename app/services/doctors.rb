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

  def self.list_patients(doctor_id, patient_store)
    patient_store.patient_with_doctor_id(doctor_id)
  end

  def self.new_consultation(doctor_id, patient_store)
    patients_options = list_patients(doctor_id, patient_store)
    Form.new(patients_options: patients_options)
  end

  def self.create_consultation(consultation_attrs, patient_store, consultation_store)
    patients_options = list_patients(consultation_attrs[:doctor_id], patient_store)
    form = Form.new(consultation_attrs.merge(patients_options: patients_options))

    if form.valid?
      consultation_store.create(consultation_attrs)
      SuccessStatus.new
    else
      ErrorStatus.new(form)
    end
  end

  class Form
    include ActiveModel::Model

    ATTRS = [:patient_id, :datetieme, :doctor_id, :patients_options]
    attr_reader(*ATTRS)

    validates_presence_of(*[:patient_id, :datetieme, :doctor_id])

    def initialize(attrs)
      ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
    end
  end

  class PatientForm
    include ActiveModel::Model

    ATTRS = [:name, :last_name, :email, :gender, :doctor_id]

    attr_accessor(*ATTRS)
    validates_presence_of(*ATTRS)

    def initialize(attrs)
       ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
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
