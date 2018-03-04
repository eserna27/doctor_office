require_relative 'patients/form'
require_relative 'status'

module Patients
  def self.create_patient_form(doctor_id)
    Patients::Form.new({"doctor_id" => doctor_id})
  end

  def self.create_patient(params, store)
    form = Patients::Form.new(params)
    if form.valid?
      store.create(form.to_h)
      Status::Success.new
    else
      Status::Error.new(form)
    end
  end

  def self.update_patient_form(patient_id, patient_store)
    patient = patient_store.find(patient_id)
    Patients::Form.new_for_edit(patient)
  end

  def self.update_patient(patient_id, params, patient_store)
    form = Patients::Form.new(params)
    if form.valid?
      patient_store.update(patient_id, form.to_h)
      Status::Success.new
    else
      Status::Error.new(form)
    end
  end

  def self.list_consultations(patient_id, doctor_id, consultation_store, patient_store)
    patient = patient_store.find(patient_id)
    ListConsultationsView.new(consultation_store.patient_consultations(patient_id, doctor_id), patient)
  end

  def self.accept_or_cancel_consultation_mail(consultation_id, consultation_store)
    consultation_store.update(consultation_id, confidencial_id: SecureRandom.uuid)
    ConsultationMailView.new(consultation_store.find(consultation_id))
  end

  def self.cancel_consultation(params, consultation_store)
    consultation = consultation_store.find_by(params)
    if consultation
      consultation_store.update(consultation.id, status: :cancel)
      ConsultationStatus.new(:success)
    else
      ConsultationStatus.new(:error)
    end
  end

  def self.accept_consultation(params, consultation_store)
    consultation = consultation_store.find_by(params)
    if consultation
      consultation_store.update(consultation.id, status: :accepted)
      ConsultationStatus.new(:success)
    else
      ConsultationStatus.new(:error)
    end
  end

  class ConsultationStatus
    attr_reader :status
    def initialize(status)
      @status = status
    end
  end

  class ConsultationMailView < SimpleDelegator
    delegate :id, :time, :confidencial_id, to: :consultation, prefix: true

    def initialize(consultation)
      @consultation = consultation
      @patient = consultation.patient
      @doctor = consultation.doctor
    end

    def patient_name
      "#{patient.name} #{patient.last_name}".titleize
    end

    def patient_email
      patient.email
    end

    def consultation_time_at
      "#{consultation_time.strftime("%H:%M")} del #{consultation_time.strftime("%d")}-#{Calendar::MONTHS[consultation_time.strftime("%_m").to_i]}-#{consultation_time.strftime("%Y")}"
    end

    def doctor_name
      "#{doctor.name} #{doctor.last_name}".titleize
    end

    attr_reader :consultation, :patient, :doctor
  end

  class ListConsultationsView < SimpleDelegator
    attr_reader :list
    delegate :id, to: :patient, prefix: true

    def initialize(list, patient)
      @list = list.map { |item| ConsultationItem.new(item) }
      @patient = patient
    end

    def patient_name
      "#{patient.name} #{patient.last_name}".titleize
    end

    private
    attr_reader :patient

    class ConsultationItem < SimpleDelegator
      attr_reader :consultation

      delegate :diagnostic, :id, :time, to: :consultation

      def initialize(consultation)
        @consultation = consultation
      end

      def terminated_at
        if consultation.terminated_at
          "#{consultation.terminated_at.strftime("%d")}-#{Calendar::MONTHS[consultation.terminated_at.strftime("%_m").to_i]}-#{consultation.terminated_at.strftime("%Y")}"
        else
        end
      end

      def status
        return "" if terminated_at
        if consultation
          return "Pendiente" if consultation.status == "pending"
          return "Cancelada" if consultation.status == "cancel"
          return "Acceptada" if consultation.status == "accepted"
        end
      end

      def status_class
        return "" if terminated_at
        if consultation
          return "text-warning" if consultation.status == "pending"
          return "text-danger" if consultation.status == "cancel"
          return "text-success" if consultation.status == "accepted"
        end
      end

      def time_at
        "#{time.strftime("%d")}-#{Calendar::MONTHS[time.strftime("%_m").to_i]}-#{time.strftime("%Y")}"
      end
    end
  end
end
