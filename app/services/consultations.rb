require_relative 'calendar'
require "active_support"

module Consultations
  def self.new_consultation_with_time(params, patients_store)
    patients_options = patients_store.patient_with_doctor_id(params[:doctor_id]).
      map { |patient| ["#{patient.name} #{patient.last_name}".titleize, patient.id] }
    Form.new(time: DateTime.parse(params[:time]), patients_options: patients_options)
  end

  def self.create_consultation(params, consultation_store, patients_store)
    patients_options = patients_store.patient_with_doctor_id(params[:doctor_id]).
      map { |patient| ["#{patient.name} #{patient.last_name}".titleize, patient.id] }
    form = Form.new({
      time: DateTime.parse(params[:time]),
      patient_id: params[:patient_id],
      doctor_id: params[:doctor_id],
      patients_options: patients_options
    })
    if form.valid?
      consultation_store.create(form.to_h)
      SuccessStatus.new
    else
      ErrorStatus.new(form)
    end
  end

  class Form
    include ActiveModel::Model

    ATTRS = [:time, :patient_id, :patients_options, :doctor_id]

    attr_accessor(*ATTRS)
    validates_presence_of(*[:time, :patient_id, :doctor_id])

    def initialize(attrs)
       ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
    end

    def time_label
      time.strftime("%H:%M")
    end

    def day_label
      "#{time.strftime("%d")}-#{Calendar::MONTHS[time.strftime("%_m").to_i]}-#{time.strftime("%Y")}"
    end

    def to_h
      {
        time: time,
        patient_id: patient_id,
        doctor_id: doctor_id
      }
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
