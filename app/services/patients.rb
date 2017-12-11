module Patients
  def self.list_consultations(patient_id, doctor_id, consultation_store, patient_store)
    patient = patient_store.find(patient_id)
    ListConsultationsView.new(consultation_store.patient_consultations(patient_id, doctor_id), patient)
  end

  def self.accept_or_cancel_consultation_mail(consultation_id, consultation_store)
    ConsultationMailView.new(consultation_store.find(consultation_id))
  end

  class ConsultationMailView < SimpleDelegator
    delegate :id, :time, to: :consultation, prefix: true

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

      def time_at
        "#{time.strftime("%d")}-#{Calendar::MONTHS[time.strftime("%_m").to_i]}-#{time.strftime("%Y")}"
      end
    end
  end
end
